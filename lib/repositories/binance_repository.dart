import 'package:dio/dio.dart';
import 'package:le_crypto_alerts/support/utils.dart';

const String BINANCE_API_URL = "https://api.binance.com";

class BinanceTickerPrice {
  final String symbol;
  final double price;

  BinanceTickerPrice({this.symbol, this.price});
}

class BinanceRepository {
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
        .map((symbol) => new Pair(exchange: Exchange.BINANCE, exchangePair: symbol['symbol'], base: symbol['baseAsset'], quote: symbol['quoteAsset']))
        .toList();
  }
}
