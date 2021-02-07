import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:le_crypto_alerts/repositories/binance/binance_support.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:sembast/timestamp.dart';

class BinanceRepository {
  String apiKey;

  String apiSecret;

  BinanceRepository({this.apiKey, this.apiSecret});

  //region DIO

  Dio _dio({bool sign = false}) {
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
          if (sign != true) return;

          final isGet = options.method == "GET";
          final parameters = ((isGet ? options.queryParameters : options.data) ?? Map<String, dynamic>()) as Map;
          final query = parameters.entries.map((e) => e.key + "=" + e.value.toString()).join("&");

          final hmac = Hmac(sha256, utf8.encode(apiSecret));
          final signature = hmac.convert(utf8.encode(query));

          // 71c3318013e066023b5633cf80dac230212faf65b4e1a5bd402d71de23c53034

          options.headers['X-MBX-APIKEY'] = apiKey;

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
    bool sign: false,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) {
    return _dio(sign: sign).get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> _doPost<T>(
    String path, {
    bool sign: false,
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) {
    return _dio(sign: sign).post<T>(
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
  Future<List<BinanceCapitalConfig>> getCapitalConfigGetAll() async {
    try {
      final response = await _doGet<List>(
        "$BINANCE_API_URL/sapi/v1/capital/config/getall",
        sign: true,
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

  Future<List<Pair>> getExchangePairs() async {
    var exchangeInfo = await getExchangeInfo();

    if (exchangeInfo == null) {
      return List<Pair>.empty();
    }

    return List.from(exchangeInfo.symbols)
        .map((symbol) => new Pair(exchange: Exchange.BINANCE, base: symbol['baseAsset'], quote: symbol['quoteAsset']))
        .toList();
  }

  String convertPairToSymbol(Pair pair) {
    if (pair == null) return null;
    return pair.base + pair.quote;
  }
}
