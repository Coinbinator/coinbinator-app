import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:sembast/timestamp.dart';

const String BINANCE_API_URL = "https://api.binance.com";

class BinanceTickerPrice {
  final String symbol;
  final double price;

  BinanceTickerPrice({this.symbol, this.price});
}

class BinanceRepository {
  String apiKey;

  String apiSecret;

  BinanceRepository({
    this.apiKey,
    this.apiSecret,
  });

  Future<Map<String, dynamic>> getExchangeInfo() async {
    try {
      var response = await Dio().get("$BINANCE_API_URL/api/v3/exchangeInfo",
          options: RequestOptions(
            responseType: ResponseType.json,
          ));
      return response.data;
    } catch (e) {
      print("err: getExchangeInfo");
      print(e);
    }
    return null;
  }

  Future<List<BinanceTickerPrice>> getTickerPrice() async {
    try {
      var response = await Dio().get("$BINANCE_API_URL/api/v3/ticker/price",
          options: RequestOptions(
            responseType: ResponseType.json,
          ));

      return List.from(response.data)
          //
          .map<BinanceTickerPrice>((ticker) => new BinanceTickerPrice(
                symbol: ticker["symbol"],
                price: double.parse(ticker["price"]),
              ))
          .toList();
    } catch (e) {
      print("err: getTickerPrice");
      print(e);
    }
    return null;
  }

  Future<List<Pair>> getExchangePairs() async {
    var exchangeInfo = await getExchangeInfo();

    if (exchangeInfo == null) {
      return List<Pair>.empty();
    }

    return List.from(exchangeInfo['symbols'])
        //
        .map((symbol) => new Pair(exchange: Exchange.BINANCE, base: symbol['baseAsset'], quote: symbol['quoteAsset']))
        .toList();
  }

  String convertPairToSymbol(Pair pair) {
    if (pair == null) return null;
    return pair.base + pair.quote;
  }

  getWalletInfo() async {
    try {
      final dio = Dio(BaseOptions(
        headers: {
          "Content-Type": "application/json",
          if (apiKey != null) 'X-MBX-APIKEY': apiKey,
        },
      ))
        ..interceptors.add(InterceptorsWrapper(
          onRequest: (options) {
            final isGet = options.method == "GET";
            final data = ((isGet ? options.queryParameters : options.data) ?? Map<String, dynamic>()) as Map;
            final query = data.entries
                // .where((element) {
                //   if (element.key == "timestamp") {
                //     return false;
                //   }
                //   return true;
                // })
                .map((e) => e.key + "=" + e.value.toString())
                .join("&");

            final hmac = Hmac(sha256, utf8.encode(apiSecret));
            final signature = hmac.convert(utf8.encode(query));

            // 71c3318013e066023b5633cf80dac230212faf65b4e1a5bd402d71de23c53034

            if (isGet) {
              // options.path = options.path + "?" + query + "signature=" + signature.toString();
              options.queryParameters.addAll({
                "signature": signature.toString(),
              });
            } else
              options.data.addAll({
                "signature": signature.toString(),
              });

            options.toString();
          },
        ));

      final response = await dio.get("$BINANCE_API_URL/sapi/v1/capital/config/getall",
          options: RequestOptions(
            queryParameters: {
              "timestamp": Timestamp.now().millisecondsSinceEpoch ,
              "recvWindow": 50000,
            },
            responseType: ResponseType.json,
          ));

      return response.data as List;
    } catch (e) {
      print(e);
    }
  }
}
