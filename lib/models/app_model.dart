import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

class AppModel extends ChangeNotifier {
  List<AbstractExchangeAccount> accounts = [];

  void init() async {
    this.accounts = await app().getAccounts();

    notifyListeners();
  }
}
