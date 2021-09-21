import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/daos/AppDao.dart';
import 'package:le_crypto_alerts/database/app_database.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/accounts/binance_account.dart';
import 'package:le_crypto_alerts/metas/accounts/mercado_bitcoin_account.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/tickers.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/pages/le_app_model.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_model.dart';
import 'package:le_crypto_alerts/repositories/alarming/alarming_repository.dart';
import 'package:le_crypto_alerts/repositories/app/_alerts_app_context.dart';
import 'package:le_crypto_alerts/repositories/background_service/background_service_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_repository.dart';
import 'package:le_crypto_alerts/support/abstract_app_ticker_listener.dart';
import 'package:le_crypto_alerts/metas/rates.dart';
import 'package:le_crypto_alerts/support/metas.dart';
import 'package:provider/provider.dart';

part '_support.dart';

_AppRepository app() {
  return _AppRepository._instance;
}

T instance<T>() => _AppRepository._instance._singletons[T];

class _AppRepository with AlertsAppContext {
  static final _instance = _AppRepository();

  bool _configLoaded = false;

  final config = _AppConfig();

  // final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  AppDatabase _persistence;

  AppDatabase get persistence => _persistence;

  AppDao get appDao => _persistence?.appDao;

  final _singletons = Map<Type, dynamic>();

  final tickers = Tickers();

  final _tickerListeners =
      List<AbstractAppTickerListener>.empty(growable: true);

  List<AbstractAppTickerListener> get tickerListeners => _tickerListeners;

  final rates = Rates();

  // alert entity stream
  Stream<List<AlertEntity>> alertsStream;

  // alert eneity subscription instance
  // ignore: cancel_subscriptions
  StreamSubscription<List<AlertEntity>> alertsStreamSubscription;

  // current list of alerts entitties instances
  List<AlertEntity> alerts = [];

  // current list of alerts entitties instances
  Set<AlertEntity> alertsActive = {};

  _AppRepository() {
    this._singletons.addAll({
      /// CORE
      AlarmingRepository: AlarmingRepository.getPlatformRepositoryInstance(),
      BackgroundServiceRepository: BackgroundServiceRepository(),

      /// Exchanges
      BinanceRepository: BinanceRepository(),
      MercadoBitcoinRepository: MercadoBitcoinRepository(),
    });
  }

  T instance<T>() {
    if (T is PortfolioListModel)
      throw Exception("deprecated models em singleton");

    return _singletons[T];
  }

  Future<void> loadConfig() async {
    if (_configLoaded) return;
    _configLoaded = true;

    await DotEnv.load(fileName: ".env");

    // building database
    _persistence = await AppDatabase.build();

    // creating global listeners
    alertsStream = appDao.findAllAlertsAsStream();
    alertsStreamSubscription = alertsStream.listen((event) {
      setAlerts(event);
    });
    setAlerts(await alertsStream.first);

    // debug accounts
    config.test_binance_api_key = env[TEST_BINANCE_API_KEY];
    config.test_binance_api_secret = env[TEST_BINANCE_API_SECRET];
    assert(config.test_binance_api_key != null);
    assert(config.test_binance_api_secret != null);

    config.test_mercado_bitcoin_tapi_id = env[TEST_MERCADO_BITCOIN_TAPI_ID];
    config.test_mercado_bitcoin_tapi_secret =
        env[TEST_MERCADO_BITCOIN_TAPI_SECRET];
    assert(config.test_mercado_bitcoin_tapi_id != null);
    assert(config.test_mercado_bitcoin_tapi_secret != null);
  }

  /// ACCOUNTS
  /// ACCOUNTS
  /// ACCOUNTS

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
    return accounts.firstWhere((account) => account.id == accountId,
        orElse: () => null);
  }

  Future<PortfolioAccountResume> getAccountPortfolioResume(
      AbstractExchangeAccount account) async {
    //TODO: criar alguma forma de batch ( e limitar o numero de carteiras sendo atualizadas em paraleno )
    if (account is BinanceAccount) {
      return instance<BinanceRepository>()
          .getAccountPortfolioResume(account: account);
    }
    if (account is MercadoBitcoinAccount) {
      return instance<MercadoBitcoinRepository>()
          .getAccountPortfolioResume(account: account);
    }
    throw Exception("tipo de conta desconhecido");
  }

  getAccountPortfolioTransactions(AbstractExchangeAccount account) async {}

  /// ALERTS
  /// ALERTS
  /// ALERTS

  setAlerts(List<AlertEntity> value) {
    this.alerts = value;
    //TODO: verificar se é necessario atualizar o triggers ( se o valores dispararam nessa troca )
  }

  DateTime updateAlertsStateAt = DateTime.now();

  updateAlertsState() async {
    //TODO: refactor to be a throttled function and not a IS/ISNOT thing
    final now = DateTime.now();
    if (now.difference(updateAlertsStateAt).inSeconds < 5) return;
    updateAlertsStateAt = now;

    Set<AlertEntity> updatePendingAlerts = {};

    for (final alert in alerts) {
      final ticker = tickers.getTicker(
          Exchanges.Binance, Pairs.getPair2(alert.coin, CoinsEx.USD_ALIASES),
          register: true);

      // NOTE:
      // validating ticker state
      if (ticker == null) continue;
      if (ticker.price == null || ticker.price < 0) continue;

      //NOTE:
      // alert is not active so we will test if it should be
      if (!alert.isActive) {
        if (!alert.testTrigger(ticker.price)) continue;

        alert.triggerState = AlertEntityState.STATE_ACTIVE;
        alert.triggerAt = DateTime.now();
        updatePendingAlerts.add(alert
          ..triggerState = AlertEntityState.STATE_ACTIVE
          ..triggerAt = DateTime.now());

        continue;
      }

      //NOTE:
      // alert is active
      // so we will check if it shoulding be
      if (alert.isActive) {
        if (alert.testTrigger(ticker.price)) continue;
        if (now.difference(alert.triggerAt).inSeconds <= 10) continue;

        updatePendingAlerts
            .add(alert..triggerState = AlertEntityState.STATE_IDLE);
        continue;
      }
    }

    if (updatePendingAlerts.isNotEmpty) {
      await appDao.updateAlerts(updatePendingAlerts);
    }
  }

  /// TICKERS
  /// TICKERS
  /// TICKERS

  void updateTicker(Ticker newTicker) {
    //NOTE: desabilitando todos os pares que não forem USD
    if (!newTicker.pair.quote.isUSD) return;

    final staticTicker =
        tickers.getTicker(newTicker.exchange, newTicker.pair, register: true);

    // nothing changed
    if (staticTicker.price == newTicker.price) return;

    staticTicker.price = newTicker.price;
    staticTicker.date = newTicker.date;

    _tickerListeners.forEach((listener) => listener.onTicker(staticTicker));

    updateAlertsState();
  }
}
