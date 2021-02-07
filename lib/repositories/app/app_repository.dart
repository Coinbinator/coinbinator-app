import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

class _AppConfig {
  // ignore: non_constant_identifier_names
  String test_binance_api_key;

  // ignore: non_constant_identifier_names
  String test_binance_api_secret;
}

class _AppRepository {
  static final instance = _AppRepository();

  final _AppConfig config = _AppConfig();

  Future<void> loadConfig() async {
    config.test_binance_api_key = env['TEST_BINANCE_API_KEY'];
    config.test_binance_api_secret = env['TEST_BINANCE_API_SECRET'];
  }
}

_AppRepository app() {
  return _AppRepository.instance;
}
