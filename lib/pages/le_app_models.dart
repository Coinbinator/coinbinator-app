import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class LeAppModel extends ChangeNotifier {
  List<AbstractExchangeAccount> accounts = [];

  List<AlertEntity> currentActiveAlerts = [];
  StreamSubscription<List<AlertEntity>> currentActiveAlertsSubscription;

  void init() async {
    accounts = await app().getAccounts();

    _updateAlerts(app().alerts);
    currentActiveAlertsSubscription =
        app().alertsStream.listen((alerts) => _updateAlerts(alerts));

    notifyListeners();
  }

  @override
  void dispose() {
    currentActiveAlertsSubscription.cancel();
    currentActiveAlertsSubscription = null;
    super.dispose();
  }

  void _updateAlerts(List<AlertEntity> value) {
    if (value == null) return;
    currentActiveAlerts = value.where((element) => element.isActive).toList();
    notifyListeners();
  }
}

class LeAppMainProgressIndicatorNotifier extends ChangeNotifier {
  Set<BusyToken> tokens = {};

  bool get isWorking => tokens.isNotEmpty;

  BusyToken busyToken({
    final String messagee,
  }) {
    final token = BusyToken(_releaseToken, message: messagee);

    tokens.add(token);

    try {
      notifyListeners();
    } catch (e) {}

    return token;
  }

  _releaseToken(final BusyToken token) {
    tokens.remove(token);

    try {
      notifyListeners();
    } catch (e) {}
  }
}
