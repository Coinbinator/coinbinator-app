import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_support.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';
import 'package:le_crypto_alerts/support/coins.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:sembast/timestamp.dart';

class BinanceRepository {
  Timestamp _ratesUpdatedAt;

  BinanceRepository();

  //region DIO

  Dio _dio({BinanceAccount account = null}) {
    final dio = Dio();
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options) {
          if (options.headers["Content-Type"] == null) options.headers["Content-Type"] = "application/json";

          if (options.responseType == null) options.responseType = ResponseType.json;
        },
      ),
      InterceptorsWrapper(
        onRequest: (options) {
          if (account == null) return;

          final isGet = options.method == "GET";
          final parameters = ((isGet ? options.queryParameters : options.data) ?? Map<String, dynamic>()) as Map;
          final query = parameters.entries.map((e) => e.key + "=" + e.value.toString()).join("&");

          final hmac = Hmac(sha256, utf8.encode(account.apiSecret));
          final signature = hmac.convert(utf8.encode(query));

          // 71c3318013e066023b5633cf80dac230212faf65b4e1a5bd402d71de23c53034

          options.headers['X-MBX-APIKEY'] = account.apiKey;

          if (isGet) {
            options.queryParameters.addAll({"signature": signature.toString()});
          } else {
            options.data.addAll({"signature": signature.toString()});
          }

          options.toString();
        },
      ),
    ]);

    return dio;
  }

  Future<Response<T>> _doGet<T>(
    String path, {
    BinanceAccount account,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) {
    return _dio(account: account).get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> _doPost<T>(
    String path, {
    BinanceAccount account,
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) {
    return _dio(account: account).post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  //endregion

  /// Exchange Info
  Future<BinanceExchangeInformation> getExchangeInfo() async {
    try {
      final response = await _doGet<Map<String, dynamic>>("$BINANCE_API_URL/api/v3/exchangeInfo");
      if (response.statusCode != 200) throw HttpException("Api Error", uri: response.request.uri);

      return BinanceExchangeInformation.fromJson(response.data);
    } catch (e) {
      print("err: getExchangeInfo");
      print(e);
    }
    return null;
  }

  /// Ticker Price
  Future<List<BinanceTickerPrice>> getTickerPrice() async {
    try {
      final response = await _doGet<List>("$BINANCE_API_URL/api/v3/ticker/price");
      if (response.statusCode != 200) throw HttpException("Api Error", uri: response.request.uri);

      return response.data.map<BinanceTickerPrice>((ticker) => BinanceTickerPrice.fromJson(ticker)).toList();
    } catch (e) {
      print("err: getTickerPrice");
      print(e);
    }
    return null;
  }

  /// Capital Config GetAll
  Future<List<BinanceCapitalConfig>> getCapitalConfigGetAll({BinanceAccount account}) async {
    try {
      final response = await _doGet<List>(
        "$BINANCE_API_URL/sapi/v1/capital/config/getall",
        account: account,
        queryParameters: {
          "timestamp": Timestamp.now().millisecondsSinceEpoch,
        },
      );
      if (response.statusCode != 200) throw HttpException("Api Error", uri: response.request.uri);

      return response.data.map((e) => BinanceCapitalConfig.fromJson(e)).toList();
    } catch (e) {
      print("err: getWalletInfo");
      print(e);
    }
    return null;
  }

  @deprecated
  Future<List<Pair>> getExchangePairs() async {
    var exchangeInfo = await getExchangeInfo();

    if (exchangeInfo == null) {
      return List<Pair>.empty();
    }

    return List.from(exchangeInfo.symbols)
        .map((symbol) => new Pair(
              // exchange: Exchange.BINANCE,
              base: symbol['baseAsset'],
              quote: symbol['quoteAsset'],
            ))
        .toList();
  }

  @deprecated
  String convertPairToSymbol(Pair pair) {
    if (pair == null) return null;
    return pair.base + pair.quote;
  }

  Future<void> updateRates() async {
    final tickers = await getTickerPrice();
    for (final ticker in tickers) {
      // ticker
      // .
    }
  }

  Future<PortfolioWalletResume> getAccountPortfolio({BinanceAccount account}) async {
    final capitals = await getCapitalConfigGetAll(account: account);

    if (capitals == null) {
      //TODO: log error
      return null;
    }

    final Map<Coin, PortfolioWalletCoin> coins = capitals.asMap().map((_, capital) {
      final portfolioCoinAmount = [
        E.toDouble(capital.free),
        E.toDouble(capital.freeze),
        E.toDouble(capital.ipoable),
        E.toDouble(capital.ipoing),
        E.toDouble(capital.locked),
        E.toDouble(capital.storage),
        E.toDouble(capital.withdrawing),
      ].fold(0.0, (a, b) => a + b);

      if (portfolioCoinAmount <= 0.0) {
        return null;
      }

      final coin = capital.leCoin;
      final portfolioCoin = PortfolioWalletCoin()
            ..coin = coin
            ..amount = portfolioCoinAmount
          // ..btcRate = getCoinRate(coin, Coins.$BTC)
          // ..usdRate = getCoinRate(coin, Coins.$USD)
          ;

      return MapEntry<Coin, PortfolioWalletCoin>(coin, portfolioCoin);
    })
      ..removeWhere((key, value) => value == null || value.amount <= 0.0);

    return PortfolioWalletResume()
      ..name = account.name
      ..coins = coins;
  }
}
