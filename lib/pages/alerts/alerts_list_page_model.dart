import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/abstract_app_ticker_listener.dart';
import 'package:le_crypto_alerts/support/flutter/ProviderUtil.dart';

class AlertsListPageModel extends ChangeNotifier
    with ModelUtilMixin, AbstractAppTickerListener {
  Stream<List<AlertEntity>> alertsStream;

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
    alertsStream = app().appDao.findAllAlertsAsStream();
    alertsStreamSubscription = alertsStream.listen((event) {
      _updateAlerts(event);
      notifyListeners();
    });
    _updateAlerts(await alertsStream.first);

    ///
    app().tickerListeners.add(this);

    ///
    status = ModelStatus.INITIALIZED;
    notifyListeners();
  }

  dispose() {
    app().tickerListeners.remove(this);
    this.alertsStreamSubscription.cancel();
    super.dispose();
  }

  _updateAlerts(List<AlertEntity> newAlerts) {
    this.alerts = newAlerts;
    alertsCoins.clear();
    for (final alert in newAlerts) alertsCoins.add(alert.coin);
  }

  @override
  FutureOr<void> onTicker(Ticker ticker) async {
    if (Coins.$USDT != ticker.pair.quoteCoin) return;
    if (!alertsCoins.contains(ticker.pair.baseCoin)) return;

    coinsCurrentPrices[ticker.pair.baseCoin] = ticker.price;
    notifyListeners();
    // print('alert ticker');
    // print(ticker);
  }

  // void showAddAlert(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertsCreatePage(),
  //     barrierDismissible: true,
  //   );
  // }
}
