import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:le_crypto_alerts/consts.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class _AppConfig {
  // ignore: non_constant_identifier_names
  String test_binance_api_key;

  // ignore: non_constant_identifier_names
  String test_binance_api_secret;
}

class _AppRepository {
  static final _instance = _AppRepository();

  bool _configLoaded = false;

  final config = _AppConfig();

  final _singletons = Map<Type, dynamic>();

  _AppRepository() {
    this._singletons.addAll({
      BinanceRepository: BinanceRepository(),
    });
  }

  Future<void> loadConfig() async {
    if (_configLoaded) return;

    await DotEnv.load(fileName: ".env");

    config.test_binance_api_key = env[TEST_BINANCE_API_KEY];
    config.test_binance_api_secret = env[TEST_BINANCE_API_SECRET];

    _configLoaded = true;
  }
}

_AppRepository app() {
  return _AppRepository._instance;
}

T instance<T>() {
  return _AppRepository._instance._singletons[T];
}
