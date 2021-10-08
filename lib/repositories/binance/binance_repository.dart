import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:le_crypto_alerts/metas/accounts/binance_account.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_orders_resume.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_support.dart';
import 'package:le_crypto_alerts/support/abstract_exchange_repository.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/metas.dart';
import 'package:sembast/timestamp.dart';
import 'package:web_socket_channel/io.dart';

part '_binance_websocket_mixin.dart';

String _convertPairToString(Pair value) => value == null ? null : "${value.base.symbol}${value.quote.symbol}";

Pair _convertStringToPair(String value) {
  if (value == null || value.isEmpty) return null;

  final pair = Pairs.getPair(value);
  if (pair != null) return pair;

  throw Exception('Unable to convert string ($value) to pair instance');
}

Pair _tryConvertStringToPair(String value) {
  try {
    return _convertStringToPair(value);
  } catch (e) {}
  return null;
}

class BinanceRepository extends AbstractExchangeRepository<BinanceAccount> with _BinanceWebSocket {
  int _serverTimeDelta;

  Timestamp _ratesUpdatedAt;

  //region DIO

  Dio _dio({BinanceAccount account}) {
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

  Future<int> get _timestampNormalized async {
    //NOTE: local and server time divergence workaround
    if (_serverTimeDelta == null) {
      final info = await getExchangeInfo();
      _serverTimeDelta = info.serverTime - Timestamp.now().millisecondsSinceEpoch;
      // print(Timestamp.fromMillisecondsSinceEpoch(info.serverTime));
    }
    // print(Timestamp.now());
    // print(_serverTimeDelta);
    // print(Timestamp.fromMillisecondsSinceEpoch(Timestamp.now().millisecondsSinceEpoch + _serverTimeDelta));
    return Timestamp.now().millisecondsSinceEpoch + _serverTimeDelta;
  }

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
    assert(account != null, "é necessario uma conta para atenticar a requisição");

    try {
      final response = await _doGet<List>(
        "$BINANCE_API_URL/sapi/v1/capital/config/getall",
        account: account,
        queryParameters: {
          "timestamp": await _timestampNormalized,
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

  /// My Trades
  Future<List<BinanceTrade>> getMyTrades({BinanceAccount account, Pair pair}) async {
    try {
      final response = await _doGet<List>(
        "$BINANCE_API_URL/api/v3/myTrades",
        account: account,
        queryParameters: {
          "symbol": _convertPairToString(pair),
          "timestamp": await _timestampNormalized,
        },
      );

      if (response.statusCode != 200) throw HttpException("Api Error", uri: response.request.uri);

      return response.data.map<BinanceTrade>((ticker) => BinanceTrade.fromJson(ticker)).toList();
    } catch (e) {
      print("err: getMyTrades");
      print(e);
    }

    return null;
  }

  /// All Orders
  Future<List<BinanceOrder>> getAllOrders({BinanceAccount account, Pair pair}) async {
    try {
      final response = await _doGet<List>(
        "$BINANCE_API_URL/api/v3/allOrders",
        account: account,
        queryParameters: {
          "symbol": _convertPairToString(pair),
          "timestamp": await _timestampNormalized,
        },
      );

      if (response.statusCode != 200) throw HttpException("Api Error", uri: response.request.uri);

      print(response);

      return response.data.map<BinanceOrder>((order) => BinanceOrder.fromJson(order)).toList();
    } catch (e) {
      print("err: getAllOrders");
      print(e);
    }

    return null;
  }

  Future<void> updateRates() async {
    final tickers = await getTickerPrice();
    if (tickers == null) {
      //TODO: notify erro atualizando rates
      return;
    }

    for (final ticker in tickers) {
      if (ticker.lePair == null) {
        //TODO: validar pares desconhecidos
        continue;
      }
      if (ticker.lePair.baseCoin == null || ticker.lePair.quoteCoin == null) {
        //TODO: validar coins desconecidas
        continue;
      }

      app().rates.updateRate(ticker.lePair.baseCoin, ticker.lePair.quoteCoin, double.tryParse(ticker.price));
    }

    _ratesUpdatedAt = Timestamp.now();
  }

  Future<PortfolioAccountResume> getAccountPortfolioResume({BinanceAccount account}) async {
    //TODO: adicionar validacao e nao atualizar rates se a ultima atualizacao foi recente
    updateRates();

    final capitals = await getCapitalConfigGetAll(account: account);

    if (capitals == null) {
      //TODO: log error
      return null;
    }

    // <Coin, PortfolioWalletCoin>
    // var coins = capitals.asMap().map((_, capital) {
    var coins = capitals.map((capital) {
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
      final portfolioCoin = PortfolioAccountResumeAsset()
        ..coin = coin
        ..amount = portfolioCoinAmount
        ..btcRate = app().rates.getRateFromTo(coin, Coins.$BTC, amount: portfolioCoinAmount)
        ..usdRate = app().rates.getRateFromTo(coin, Coins.$USD, amount: portfolioCoinAmount)
        ..brlRate = app().rates.getRateFromTo(coin, Coins.$BRL, amount: portfolioCoinAmount);

      return portfolioCoin;
    }).toList();

    coins
      ..removeWhere((value) => value == null || value.amount <= 0.0)
      ..sort((a, b) => a.baseRate < b.baseRate ? 1 : -1);

    return PortfolioAccountResume()
      ..account = account
      ..coins = coins;
  }

  @override
  Future<PortfolioAccountOrdersResume> getAccountOrderHistoryResume({BinanceAccount account}) async {
    //TODO: these pairs should be configured on BinanceAccount settings
    final pairs = [
      Pairs.$BTC_USDT,
      // Pairs.$BTC_USDC,
      Pairs.$ETH_USDT,
      // Pairs.$ETH_USDC,
    ];
    final ordersByPair = await Future.wait(pairs.map((pair) => getAllOrders(account: account, pair: pair)));

    return new PortfolioAccountOrdersResume()
      ..account = account
      ..orders = [
        for (final orders in ordersByPair)
          for (final order in orders)
            PortfolioAccountOrderResume()
              ..pair = _convertStringToPair(order.symbol)
              ..type = order.type
              ..status = order.status
              ..filled = order.origQty == order.executedQty
              ..quantity = order.origQty
              ..executedQuantity = order.executedQty
              ..priceLimit = order.stopPrice
              ..priceAvg = order.executedQty
              ..createdAt = DateTime.fromMillisecondsSinceEpoch(order.time)
              ..updatedAt = DateTime.fromMillisecondsSinceEpoch(order.time),
      ];
  }
}
