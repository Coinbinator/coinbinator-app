part of 'app_repository.dart';

enum _AppRepositoryState {
  UNINITIALIZED,
  INITIALIZING,
  INITIALIZED,
}

class _AppConfig {
  // ignore: non_constant_identifier_names
  String test_binance_api_key;

  // ignore: non_constant_identifier_names
  String test_binance_api_secret;

  // ignore: non_constant_identifier_names
  String test_mercado_bitcoin_tapi_id;

  // ignore: non_constant_identifier_names
  String test_mercado_bitcoin_tapi_secret;
}

T instance<T>() => _AppRepository._instance._singletons[T];

_AppRepository app() {
  return _AppRepository._instance;
}
