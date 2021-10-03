import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
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
  Set<Coin> coinsOnAlerts = {};

  ///
  Map<Coin, Ticker> coinCurrentTickers = {};

  ///
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
    coinsOnAlerts = null;
    coinCurrentTickers = null;
    selectedAlerts = null;
    super.dispose();
  }

  setAlerts(List<AlertEntity> newAlerts) {
    this.alerts = newAlerts;

    coinsOnAlerts.clear();
    coinCurrentTickers.clear();

    for (final alert in newAlerts) {
      coinsOnAlerts.add(alert.coin);
      coinCurrentTickers[alert.coin] = Ticker.fromTicker(app().tickers.getTickerForAlertEntity(alert));
    }

    notifyListeners();
  }

  sertAlertSelection(AlertEntity alert) {
    selectedAlerts.add(alert);
  }

  @override
  FutureOr<void> onTickers(List<Ticker> tickers) async {
    bool dirty = false;

    for (final ticker in tickers) {
      if (ticker == null) continue;
      if (!ticker.pair.quoteCoin.isUSD) continue;
      if (!coinsOnAlerts.contains(ticker.pair.baseCoin)) continue;

      dirty = true;
    }

    if (dirty) notifyListeners();
  }

  @override
  Iterable<AlertEntity> get itemsSelectionSource => alerts;
}
