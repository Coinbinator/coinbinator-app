import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

class SplashModel extends ChangeNotifier {
  String initializetionMessage = "";

  setInitializetionMessage(String value) {
    initializetionMessage = value;
    notifyListeners();
  }
}
