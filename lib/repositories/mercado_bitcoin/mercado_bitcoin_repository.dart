import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:le_crypto_alerts/metas/accounts/mercado_bitcoin_account.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_support.dart';
import 'package:le_crypto_alerts/support/abstract_exchange_repository.dart';
import 'package:sembast/timestamp.dart';

const API_URL = 'https://www.mercadobitcoin.com.br/api/';
const TAPI_URL = 'https://www.mercadobitcoin.com.br/tapi/v3/';
const TAPI_URI = '/tapi/v3/';

class MercadoBitcoinRepository extends AbstractExchangeRepository<MercadoBitcoinAccount> {
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

    // print(json.encode(response.data));

    return response.data;
  }

  Future<MercadoBitcoinAccountInfo> getAccountInfo({MercadoBitcoinAccount account}) async {
    final response = await _tapi(account: account, parameters: {
      'tapi_method': 'get_account_info',
      'tapi_nonce': Timestamp.now().millisecondsSinceEpoch / 100,
    });

    return MercadoBitcoinAccountInfo.fromJson(response);
  }

  Future<MercadoBitcoinListOrdersResponse> getAccountTrades({MercadoBitcoinAccount account, Pair pair}) async {
    final response = await _tapi(account: account, parameters: {
      'tapi_method': 'list_orders',
      'tapi_nonce': Timestamp.now().millisecondsSinceEpoch / 100,
      'coin_pair': 'BRLBTC',
      // 'status_list': '[2, 3]',
      // 'has_fills': 1,
    });
    print(response);
    return MercadoBitcoinListOrdersResponse.fromJson(response);
  }

  Future<PortfolioAccountResume> getAccountPortfolioResume({MercadoBitcoinAccount account}) async {
    final accountInfo = await getAccountInfo(account: account);

    return PortfolioAccountResume()
      ..account = account
      ..coins = [
        for (var e in accountInfo.responseData.balance.entries)
          PortfolioAccountResumeAsset()
            ..coin = Coins.getCoin(e.key)
            ..amount = double.tryParse(e.value.total)
            ..usdRate = app().rates.getRateFromTo(Coins.getCoin(e.key), Coins.$USD, amount: double.tryParse(e.value.total))
            ..btcRate = app().rates.getRateFromTo(Coins.getCoin(e.key), Coins.$BTC, amount: double.tryParse(e.value.total))
      ]
      //NOTE: removendo registros com balance zero
      ..coins.removeWhere((element) => element.coin == null || element.amount <= 0);
  }
}
