import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:le_crypto_alerts/consts.dart';
import 'package:le_crypto_alerts/database/Persistence.dart';
import 'package:le_crypto_alerts/main.dart';
import 'package:le_crypto_alerts/models/portfolio_model.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/user/user_repository.dart';
import 'package:le_crypto_alerts/support/rates.dart';
import 'package:le_crypto_alerts/support/tickers.dart';

part 'app_repository_support.dart';

_AppRepository app() {
  return _AppRepository._instance;
}

T instance<T>() {
  if (T is PortfolioModel) throw Exception("deprecado models em singleton");
  return _AppRepository._instance._singletons[T];
}

class _AppRepository {
  static final _instance = _AppRepository();

  final config = _AppConfig();

  final persistence = Persistence();

  final _singletons = Map<Type, dynamic>();

  bool _configLoaded = false;

  LeApp rootWidget;

  final tickers = Tickers();

  final rates = Rates();

  _AppRepository() {
    this._singletons.addAll({
      BinanceRepository: BinanceRepository(),
      UserRepository: UserRepository(),
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
