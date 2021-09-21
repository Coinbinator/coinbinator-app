import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

class LeAppModel extends ChangeNotifier {
  List<AbstractExchangeAccount> accounts = [];

  Set<AlertEntity> alertsActive = {};

  void init() async {
    this.accounts = await app().getAccounts();
    notifyListeners();
  }

  void setCurrentActiveAlarms(Set<AlertEntity> value) {
    alertsActive = alertsActive;
    notifyListeners();
  }
}
