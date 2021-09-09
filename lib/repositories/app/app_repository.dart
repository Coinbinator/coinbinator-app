import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/daos/AppDao.dart';
import 'package:le_crypto_alerts/database/persistence.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/accounts/binance_account.dart';
import 'package:le_crypto_alerts/metas/accounts/mercado_bitcoin_account.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_model.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/repositories/alarming/alarming_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/background_service_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_repository.dart';
import 'package:le_crypto_alerts/support/abstract_app_ticker_listener.dart';
import 'package:le_crypto_alerts/support/rates.dart';
import 'package:le_crypto_alerts/metas/tickers.dart';
import 'package:le_crypto_alerts/support/utils.dart';

part '_support.dart';

_AppRepository app() {
  return _AppRepository._instance;
}

T instance<T>() {
  if (T is PortfolioListModel) throw Exception("deprecated models em singleton");

  return _AppRepository._instance._singletons[T];
}

class _AppRepository {
  static final _instance = _AppRepository();

  bool _configLoaded = false;

  final config = _AppConfig();

  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  AppDatabase _persistence;

  AppDatabase get persistence => _persistence;

  AppDao get appDao => _persistence?.appDao;

  final _singletons = Map<Type, dynamic>();

  LeApp rootWidget;

  final tickers = Tickers();

  final tickerListeners = List<AbstractAppTickerListener>.empty(growable: true);

  final rates = Rates();

  _AppRepository() {
    this._singletons.addAll({
      BinanceRepository: BinanceRepository(),
      MercadoBitcoinRepository: MercadoBitcoinRepository(),
      AlarmingRepository: AlarmingRepository.getPlatformRepositoryInstance(),
      BackgroundServiceRepository: BackgroundServiceRepository(),
    });
  }

  Future<void> loadConfig() async {
    if (_configLoaded) return;

    _persistence = await AppDatabase.build();

    await DotEnv.load(fileName: ".env");

    config.test_binance_api_key = env[TEST_BINANCE_API_KEY];
    config.test_binance_api_secret = env[TEST_BINANCE_API_SECRET];
    assert(config.test_binance_api_key != null);
    assert(config.test_binance_api_secret != null);

    config.test_mercado_bitcoin_tapi_id = env[TEST_MERCADO_BITCOIN_TAPI_ID];
    config.test_mercado_bitcoin_tapi_secret = env[TEST_MERCADO_BITCOIN_TAPI_SECRET];
    assert(config.test_mercado_bitcoin_tapi_id != null);
    assert(config.test_mercado_bitcoin_tapi_secret != null);

    _configLoaded = true;
  }

  Future<List<AbstractExchangeAccount>> getAccounts() async {
    return [
      BinanceAccount()
        ..id = 1
        ..name = "Binance"
        ..apiKey = config.test_binance_api_key
        ..apiSecret = config.test_binance_api_secret,
      MercadoBitcoinAccount()
        ..id = 2
        ..name = "Mercado Bitcoin"
        ..tapiId = config.test_mercado_bitcoin_tapi_id
        ..tapiSecret = config.test_mercado_bitcoin_tapi_secret,
    ];
  }

  Future<AbstractExchangeAccount> getAccountById(int accountId) async {
    final accounts = await getAccounts();
    return accounts.firstWhere((account) => account.id == accountId, orElse: () => null);
  }

  Future<PortfolioAccountResume> getAccountPortfolioResume(AbstractExchangeAccount account) async {
    //TODO: criar alguma forma de batch ( e limitar o numero de carteiras sendo atualizadas em paraleno )
    if (account is BinanceAccount) {
      return instance<BinanceRepository>().getAccountPortfolioResume(account: account);
    }
    if (account is MercadoBitcoinAccount) {
      return instance<MercadoBitcoinRepository>().getAccountPortfolioResume(account: account);
    }
    throw Exception("tipo de conta desconhecido");
  }

  getAccountPortfolioTransactions(AbstractExchangeAccount account) async {

  }
}
