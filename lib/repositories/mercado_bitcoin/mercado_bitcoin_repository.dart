import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';
import 'package:le_crypto_alerts/support/coins.dart';
import 'package:le_crypto_alerts/support/pairs.dart';
import 'package:le_crypto_alerts/support/rates.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_support.dart';
import 'package:sembast/timestamp.dart';
import 'package:sqflite/utils/utils.dart';

const API_URL = 'https://www.mercadobitcoin.com.br/api/';
const TAPI_URL = 'https://www.mercadobitcoin.com.br/tapi/v3/';
const TAPI_URI = '/tapi/v3/';

class MercadoBitcoinRepository {
  Future<Map<String, dynamic>> _tapi({MercadoBitcoinAccount account, Map<String, dynamic> parameters}) async {
    final dio = Dio();

    final query = parameters.entries.map((e) => e.key + "=" + e.value.toString()).join("&");
    // final query = 'tapi_method=list_orders&tapi_nonce=1';

    final hmac = Hmac(sha512, utf8.encode(account.tapiSecret));
    // final hmac = Hmac(sha512, utf8.encode('1ebda7d457ece1330dff1c9e04cd62c4e02d1835968ff89d2fb2339f06f73028'));

    final signature = hmac.convert(utf8.encode('$TAPI_URI?$query'));
    final signatureStr = signature.toString();

    final response = await dio.post('$TAPI_URL',
        data: query,
        options: Options(followRedirects: false, headers: {
          'Content-Type': "application/x-www-form-urlencoded",
          'TAPI-ID': account.tapiId,
          'TAPI-MAC': signatureStr,
        }));

    // c39b16cb44cc3bc468aeffafbb80d42fc0e1fee024c933e1b3face6555c0f51018ccb4d35f4e6bff63b5a41290d2cf78e143454a66a6ab31b2c3599068923885
    // c39b16cb44cc3bc468aeffafbb80d42fc0e1fee024c933e1b3face6555c0f51018ccb4d35f4e6bff63b5a41290d2cf78e143454a66a6ab31b2c3599068923885
    // 7f59ea8749ba596d5c23fa242a531746b918e5e61c9f6c8663a699736db503980f3a507ff7e2ef1336f7888d684a06c9a460d18290e7b738a61d03e25ffdeb76

    print(json.encode(response.data));

    return response.data;
  }

  Future<MercadoBitcoinAccountInfo> getAccountInfo({MercadoBitcoinAccount account}) async {
    final response = await _tapi(account: account, parameters: {
      'tapi_method': 'get_account_info',
      'tapi_nonce': Timestamp.now().millisecondsSinceEpoch / 100,
    });

    return MercadoBitcoinAccountInfo.fromJson(response);
  }

  Future<PortfolioWalletResume> getAccountPortfolio({MercadoBitcoinAccount account}) async {
    final accountInfo = await getAccountInfo(account: account);

    return PortfolioWalletResume()
      ..name = account.name
      ..coins = [
        for (var e in accountInfo.responseData.balance.entries)
          PortfolioWalletCoin()
            ..coin = Coins.getCoin(e.key)
            ..amount = double.tryParse(e.value.total)
            ..usdRate = app().rates.getRateFromTo(Coins.getCoin(e.key), Coins.$USD, amount: double.tryParse(e.value.total))
            ..btcRate = app().rates.getRateFromTo(Coins.getCoin(e.key), Coins.$BTC, amount: double.tryParse(e.value.total))
      ]
      //NOTE: removendo registros com zero balance
      ..coins.removeWhere((element) => element.coin == null || element.amount <= 0);
  }
}
