import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:le_crypto_alerts/metas/accounts/mercado_bitcoin_account.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_orders_resume.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_support.dart';
import 'package:le_crypto_alerts/support/abstract_exchange_repository.dart';
import 'package:sembast/timestamp.dart';

const API_URL = 'https://www.mercadobitcoin.com.br/api/';
const TAPI_URL = 'https://www.mercadobitcoin.com.br/tapi/v3/';
const TAPI_URI = '/tapi/v3/';

// extension MercadoBitcoinPair on Pair {
//   String toStringMercadoBitcoin() {
//     return "$base$quote";
//   }
// }

String _tapiConvertPairToString(Pair pair) => pair == null ? '' : "${pair.quote.symbol}${pair.base.symbol}";

Pair _tapiConvertStringToPair(String pair) {
  if (pair == null || pair.isEmpty) return null;

  final brlMatch = pair.split(RegExp("^(BRL)", caseSensitive: false, dotAll: false));
  if (brlMatch.length == 2) return Pairs.getPair("${brlMatch[1]}/BRL");

  throw Exception('Unable to convert string ($pair) to pair instance');
}

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

  Future<MercadoBitcoinAccountInfo> tapiGetAccountInfo({MercadoBitcoinAccount account}) async {
    final response = await _tapi(account: account, parameters: {
      'tapi_method': 'get_account_info',
      'tapi_nonce': Timestamp.now().millisecondsSinceEpoch / 100,
    });

    return MercadoBitcoinAccountInfo.fromJson(response);
  }

  Future<MercadoBitcoinListOrdersResponse> tapiListOrders({MercadoBitcoinAccount account, Pair pair}) async {
    assert(pair != null, 'pair argument must be defined');

    final response = await _tapi(account: account, parameters: {
      'tapi_method': 'list_orders',
      'tapi_nonce': Timestamp.now().millisecondsSinceEpoch / 100,
      'coin_pair': _tapiConvertPairToString(pair),
      // 'status_list': '[2, 3]',
      // 'has_fills': 1,
    });
    return MercadoBitcoinListOrdersResponse.fromJson(response);
  }

  Future<PortfolioAccountResume> getAccountPortfolioResume({MercadoBitcoinAccount account}) async {
    final accountInfo = await tapiGetAccountInfo(account: account);

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

  Future<PortfolioAccountOrdersResume> getAccountOrderHistoryResume({MercadoBitcoinAccount account}) async {
    final ordersResponses = await Future.wait(_tapiSupportedPairs.map((pair) => tapiListOrders(account: account, pair: pair)));

    return PortfolioAccountOrdersResume()
      ..account = account
      ..orders = [
        for (var orderResponse in ordersResponses)
          for (var order in orderResponse.responseData.orders)
            PortfolioAccountOrderResume()
              ..pair = _tapiConvertStringToPair(order.coinPair)
              ..type = order.orderType
              ..status = order.status
              ..filled = order.hasFills
              ..quantity = double.tryParse(order.quantity)
              ..executedQuantity = double.tryParse(order.executedQuantity)
              ..priceLimit = double.tryParse(order.limitPrice)
              ..priceAvg = double.tryParse(order.executedPriceAvg)
              ..createdAt = DateTime.fromMillisecondsSinceEpoch(order.createdTimestamp * 1000)
              ..updatedAt = DateTime.fromMillisecondsSinceEpoch(order.updatedTimestamp * 1000)
      ];

    final listOrders = await tapiListOrders(account: account, pair: Pairs.getPair("BTC/BRL"));

    return PortfolioAccountOrdersResume()
      ..account = account
      ..orders = [
        for (var e in listOrders.responseData.orders)
          PortfolioAccountOrderResume()
            ..pair = _tapiConvertStringToPair(e.coinPair)
            ..type = e.orderType
            ..status = e.status
            ..filled = e.hasFills
            ..quantity = double.tryParse(e.quantity)
            ..executedQuantity = double.tryParse(e.executedQuantity)
            ..priceLimit = double.tryParse(e.limitPrice)
            ..priceAvg = double.tryParse(e.executedPriceAvg)
            ..createdAt = DateTime.fromMillisecondsSinceEpoch(e.createdTimestamp * 1000)
            ..updatedAt = DateTime.fromMillisecondsSinceEpoch(e.updatedTimestamp * 1000)
      ];
  }
}

final List<Pair> _tapiSupportedPairs = ([
  Pairs.getPair('AAVE/BRL'),
  Pairs.getPair('ACMFT/BRL'),
  Pairs.getPair('ACORDO01/BRL'),
  Pairs.getPair('ALLFT/BRL'),
  Pairs.getPair('AMFT/BRL'),
  Pairs.getPair('ANKR/BRL'),
  Pairs.getPair('ARGFT/BRL'),
  Pairs.getPair('ASRFT/BRL'),
  Pairs.getPair('ATMFT/BRL'),
  Pairs.getPair('AXS/BRL'),
  Pairs.getPair('BAL/BRL'),
  Pairs.getPair('BAND/BRL'),
  Pairs.getPair('BARFT/BRL'),
  Pairs.getPair('BAT/BRL'),
  Pairs.getPair('BCH/BRL'),
  Pairs.getPair('BNT/BRL'),
  Pairs.getPair('BTC/BRL'),
  Pairs.getPair('CAIFT/BRL'),
  Pairs.getPair('CHZ/BRL'),
  Pairs.getPair('CITYFT/BRL'),
  Pairs.getPair('COMP/BRL'),
  Pairs.getPair('CRV/BRL'),
  Pairs.getPair('DAI/BRL'),
  Pairs.getPair('DAL/BRL'),
  Pairs.getPair('ENJ/BRL'),
  Pairs.getPair('ETH/BRL'),
  Pairs.getPair('GALFT/BRL'),
  Pairs.getPair('GRT/BRL'),
  Pairs.getPair('IMOB01/BRL'),
  Pairs.getPair('IMOB02/BRL'),
  Pairs.getPair('JUVFT/BRL'),
  Pairs.getPair('KNC/BRL'),
  Pairs.getPair('LINK/BRL'),
  Pairs.getPair('LTC/BRL'),
  Pairs.getPair('MANA/BRL'),
  Pairs.getPair('MATIC/BRL'),
  Pairs.getPair('MBCONS01/BRL'),
  Pairs.getPair('MBCONS02/BRL'),
  Pairs.getPair('MBFP01/BRL'),
  Pairs.getPair('MBFP02/BRL'),
  Pairs.getPair('MBFP03/BRL'),
  Pairs.getPair('MBFP04/BRL'),
  Pairs.getPair('MBFP05/BRL'),
  Pairs.getPair('MBPRK01/BRL'),
  Pairs.getPair('MBPRK02/BRL'),
  Pairs.getPair('MBPRK03/BRL'),
  Pairs.getPair('MBPRK04/BRL'),
  Pairs.getPair('MBPRK05/BRL'),
  Pairs.getPair('MBVASCO01/BRL'),
  Pairs.getPair('MCO2/BRL'),
  Pairs.getPair('MKR/BRL'),
  Pairs.getPair('NAVIFT/BRL'),
  Pairs.getPair('OGFT/BRL'),
  Pairs.getPair('OMG/BRL'),
  Pairs.getPair('PAXG/BRL'),
  Pairs.getPair('PFLFT/BRL'),
  Pairs.getPair('PSGFT/BRL'),
  Pairs.getPair('REI/BRL'),
  Pairs.getPair('REN/BRL'),
  Pairs.getPair('SAUBERFT/BRL'),
  Pairs.getPair('SCCPFT/BRL'),
  Pairs.getPair('SNX/BRL'),
  Pairs.getPair('SUSHI/BRL'),
  Pairs.getPair('THFT/BRL'),
  Pairs.getPair('UMA/BRL'),
  Pairs.getPair('UNI/BRL'),
  Pairs.getPair('USDC/BRL'),
  Pairs.getPair('WBTC/BRL'),
  Pairs.getPair('WBX/BRL'),
  Pairs.getPair('XRP/BRL'),
  Pairs.getPair('YFI/BRL'),
  Pairs.getPair('ZRX/BRL'),
]).where((element) => element != null).toList(growable: false);
