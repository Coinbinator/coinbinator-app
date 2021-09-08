import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class PortfolioDetailsModel extends ChangeNotifier {
  final int accountId;

  bool initialized = false;

  bool working = false;

  bool updatingPortfolios = false;

  DateTime updatedPortfoliosAt;

  Account account;

  PortfolioWalletResume portfolioResume;

  PortfolioDetailsModel(this.accountId);

  Future<void> init() async {
    if (initialized) return;

    await reloadAccounts();
    await updatePortfolios();

    initialized = true;
  }

  Future<void> reloadAccounts() async {
    account = await app().getAccountById(accountId);
    notifyListeners();
  }

  Future<void> updatePortfolios() async {
    updatingPortfolios = true;
    notifyListeners();

    portfolioResume = await app().getAccountPortfolioResume(account);
    updatedPortfoliosAt = DateTime.now();
    updatingPortfolios = false;

    notifyListeners();
  }
}
