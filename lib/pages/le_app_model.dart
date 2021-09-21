import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class LeAppModel extends ChangeNotifier {
  List<AbstractExchangeAccount> accounts = [];

  List<AlertEntity> currentActiveAlerts = [];
  StreamSubscription<List<AlertEntity>> currentActiveAlertsSubscription;

  void init() async {
    accounts = await app().getAccounts();

    setCurrentActiveAlarms(app().alerts);
    currentActiveAlertsSubscription =
        app().alertsStream.listen((alerts) => setCurrentActiveAlarms(alerts));

    notifyListeners();
  }

  @override
  dispose() {
    currentActiveAlertsSubscription.cancel();
    super.dispose();
  }

  void setCurrentActiveAlarms(List<AlertEntity> value) {
    if (value == null) return;
    currentActiveAlerts = value.where((element) => element.isActive).toList();
    notifyListeners();
  }
}
