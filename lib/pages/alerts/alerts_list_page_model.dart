import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/abstract_app_ticker_listener.dart';
import 'package:le_crypto_alerts/support/flutter/provider_urils.dart';
import 'package:le_crypto_alerts/support/metas.dart';

class AlertsListPageModel extends ChangeNotifier with ModelUtilMixin, AbstractAppTickerListener {
  ///
  StreamSubscription<List<AlertEntity>> alertsStreamSubscription;

  ///
  List<AlertEntity> alerts = [];

  ///
  Set<Coin> alertsCoins = {};

  ///
  Map<Coin, double> coinsCurrentPrices = {};

  Set<AlertEntity> selectedAlerts = {};

  init() async {
    if (status != ModelStatus.UNINITIALIZED) return;
    status = ModelStatus.INITIALIZING;

    ///
    setAlerts(app().alerts);
    alertsStreamSubscription = app().alertsStream.listen((event) {
      setAlerts(event);
    });

    ///
    app().tickerListeners.add(this);

    ///
    status = ModelStatus.INITIALIZED;
    notifyListeners();
  }

  dispose() {
    app().tickerListeners?.remove(this);
    alertsStreamSubscription?.cancel();
    alertsStreamSubscription = null;
    alerts = null;
    alertsCoins = null;
    coinsCurrentPrices = null;
    selectedAlerts = null;
    super.dispose();
  }

  setAlerts(List<AlertEntity> newAlerts) {
    this.alerts = newAlerts;

    alertsCoins.clear();
    coinsCurrentPrices.clear();

    for (final alert in newAlerts) {
      alertsCoins.add(alert.coin);
      coinsCurrentPrices[alert.coin] = app().tickers.getTicker(Exchanges.Binance, Pairs.getPair2(alert.coin, CoinsEx.USD_ALIASES))?.price ?? null;
    }

    notifyListeners();
  }

  sertAlertSelection(AlertEntity alert) {
    selectedAlerts.add(alert);
  }

  @override
  FutureOr<void> onTicker(Ticker ticker) async {
    if (ticker == null) return;
    if (!ticker.pair.quoteCoin.isUSD) return;
    if (!alertsCoins.contains(ticker.pair.baseCoin)) return;

    coinsCurrentPrices[ticker.pair.baseCoin] = ticker.price;
    notifyListeners();
  }

  @override
  Iterable<AlertEntity> get itemsSelectionSource => alerts;
}
