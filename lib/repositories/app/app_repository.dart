import 'dart:async';

import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/daos/AppDao.dart';
import 'package:le_crypto_alerts/database/app_database.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/accounts/binance_account.dart';
import 'package:le_crypto_alerts/metas/accounts/mercado_bitcoin_account.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/tickers.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_model.dart';
import 'package:le_crypto_alerts/pages/splash/splash_model.dart';
import 'package:le_crypto_alerts/repositories/alarming/alarming_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_repository.dart';
import 'package:le_crypto_alerts/repositories/speech/SpeechRepository.dart';
import 'package:le_crypto_alerts/repositories/vibrate/vibrate_repository.dart';
import 'package:le_crypto_alerts/support/abstract_app_ticker_listener.dart';
import 'package:le_crypto_alerts/metas/rates.dart';
import 'package:le_crypto_alerts/support/metas.dart';
import 'package:provider/provider.dart';

part '_app_repository_support.dart';

class _AppRepository {
  static final _instance = _AppRepository();

  _AppRepositoryState _state = _AppRepositoryState.UNINITIALIZED;

  final config = _AppConfig();

  // final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  AppDatabase _persistence;

  bool get isReady => _state == _AppRepositoryState.INITIALIZED;

  AppDatabase get persistence => _persistence;

  AppDao get appDao => _persistence?.appDao;

  final _singletons = Map<Type, dynamic>();

  final tickers = Tickers();

  final _tickerListeners = List<AbstractAppTickerListener>.empty(growable: true);

  List<AbstractAppTickerListener> get tickerListeners => _tickerListeners;

  final rates = Rates();

  DateTime updateAlertsStateAt = DateTime.now();

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
      // BackgroundServiceRepository: BackgroundServiceRepository(), //TODO: background processes needs an entire review
      SpeechRepository: SpeechRepository(),
      VibrateRepository: VibrateRepository(),

      /// Exchanges
      BinanceRepository: BinanceRepository(),
      MercadoBitcoinRepository: MercadoBitcoinRepository(),
    });
  }

  T instance<T>() {
    if (T is PortfolioListModel) throw Exception("deprecated models em singleton");

    return _singletons[T];
  }

  Future<void> init() async {
    if (_state != _AppRepositoryState.UNINITIALIZED) return;
    _state = _AppRepositoryState.INITIALIZING;

    /// shorhand para atualizacao das mensagens do Splash
    _say(String message) => MAIN_APP_WIDGET?.currentContext?.read<SplashModel>()?.setInitializetionMessage(message);

    try {
      _say("Loading configurations...");
      await DotEnv.load(fileName: ".env");

      // building database
      _persistence = await AppDatabase.build();

      // creating global listeners
      alertsStream = appDao.findAllAlertsAsStream();
      alertsStreamSubscription = alertsStream.listen((event) {
        setAlerts(event);
      });
      setAlerts(await alertsStream.first);

      //SSOCKET LISTENERS
      instance<BinanceRepository>().listenToNormalTickers(_onNormalTickerListener);

      // debug accounts
      config.test_binance_api_key = env[TEST_BINANCE_API_KEY];
      config.test_binance_api_secret = env[TEST_BINANCE_API_SECRET];
      assert(config.test_binance_api_key != null);
      assert(config.test_binance_api_secret != null);

      config.test_mercado_bitcoin_tapi_id = env[TEST_MERCADO_BITCOIN_TAPI_ID];
      config.test_mercado_bitcoin_tapi_secret = env[TEST_MERCADO_BITCOIN_TAPI_SECRET];
      assert(config.test_mercado_bitcoin_tapi_id != null);
      assert(config.test_mercado_bitcoin_tapi_secret != null);

      _say("Starting internal objects...");
      // await instance<AlarmingRepository>().initialize();
      // await instance<BackgroundServiceRepository>().initialize();

    } catch (e) {
      debugPrint("Error trying to initialize app repository");
      throw e;
    }

    _state = _AppRepositoryState.INITIALIZED;
    _say("Complete.");
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

  getAccountPortfolioTransactions(AbstractExchangeAccount account) async {}

  Future<int> persistAlertEntity(AlertEntity alert) async {
    if (alert == null) return 0;

    if (alert.id == null || alert.id <= 0) {
      return await app().appDao.insertAlert(alert);
    }

    return await app().appDao.updateAlert(alert);
  }

  Future<int> removeAlertEntity(AlertEntity alert) async {
    if (alert == null) return 0;
    return await app().appDao.deleteAlert(alert);
  }

  setAlerts(List<AlertEntity> value) {
    //TODO: verificar se é necessario atualizar o triggers ( se o valores dispararam nessa troca )
    this.alerts = value;
  }

  Future<void> updateAlertsState() async {
    //TODO: refactor to be a throttled function and not a IS/ISNOT thing
    final now = DateTime.now();
    if (now.difference(updateAlertsStateAt).inSeconds < 5) return;
    updateAlertsStateAt = now;

    Set<AlertEntity> updatePendingAlerts = {};

    for (final alert in alerts) {
      final ticker = tickers.getTicker(Exchanges.Binance, Pairs.getPair2(alert.coin, CoinsEx.USD_ALIASES), createOnMissing: true);

      // NOTE:
      // validating ticker state
      if (ticker == null) continue;
      if (ticker.closePrice == null || ticker.closePrice < 0) continue;

      //NOTE:
      // alert is not active so we will test if it should be
      if (!alert.isActive) {
        if (!alert.testTrigger(ticker.closePrice)) continue;

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
        if (alert.testTrigger(ticker.closePrice)) continue;
        if (now.difference(alert.triggerAt).inSeconds <= 10) continue;

        updatePendingAlerts.add(alert..triggerState = AlertEntityState.STATE_IDLE);
        continue;
      }
    }

    if (updatePendingAlerts.isNotEmpty) {
      await appDao.updateAlerts(updatePendingAlerts);
    }
  }

  bool updateTickers(Iterable<Ticker> newTickers) {
    debugPrint("Updating ${newTickers.length} tickers");

    // bool anyTickerChanged = false;
    List<Ticker> changedTickers = [];
    for (final ticker in newTickers) {
      final tickerChanged = updateTicker(ticker);
      if (tickerChanged) changedTickers.add(this.tickers.getTicker(ticker.exchange, ticker.pair, createOnMissing: false));
      // anyTickerChanged = anyTickerChanged || tickerChanged;
    }

    if (changedTickers.isNotEmpty) {
      updateAlertsState();

      //NOTE: notify the ticker listener os the changed tickers
      _tickerListeners.forEach((listener) => listener.onTickers(changedTickers));
    }

    return changedTickers.isNotEmpty;
  }

  bool updateTicker(
    Ticker newTicker, {
    final bool callUpdateAlertState: false,
  }) {
    //NOTE: desabilitando todos os pares que não forem USD
    if (!newTicker.pair.quote.isUSD) return false;

    final staticTicker = tickers.getTicker(newTicker.exchange, newTicker.pair, createOnMissing: true);
    final tickerChanged = staticTicker.hasChanged(newTicker);

    staticTicker.apply(newTicker);

    if (tickerChanged) {
      // _tickerListeners.forEach((listener) => listener.onTicker(staticTicker));
      if (callUpdateAlertState) updateAlertsState();
    }

    return tickerChanged;
  }

  void _onNormalTickerListener(List<Ticker> tickers) {
    updateTickers(tickers);
  }

  @deprecated
  void receivedActiveAlerts(List<AlertEntity> activeAlerts) async {
    Bringtoforeground.bringAppToForeground();

    if (MAIN_NAVIGATOR_KEY.currentState == null) {
      // Bringtoforeground.bringAppToForeground();
    }
  }
}
