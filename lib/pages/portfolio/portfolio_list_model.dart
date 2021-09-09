import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

class PortfolioListModel extends ChangeNotifier {
  bool initialized = false;

  bool working = false;

  bool updatingPortfolios = false;

  DateTime updatedPortfoliosAt;

  List<AbstractExchangeAccount> accounts = [];

  List<PortfolioAccountResume> portfolioResumes = [];

  Map<int, bool> portfolioCardsOpened = {};

  Future<void> init() async {
    if (initialized) return;

    await reloadAccounts();
    await updatePortfolios();

    initialized = true;
  }

  Future<void> reloadAccounts() async {
    accounts = await app().getAccounts();
    notifyListeners();
  }

  Future<void> updatePortfolios() async {
    updatingPortfolios = true;
    notifyListeners();

    //TODO: criar alguma forma de batch ( e limitar o numero de carteiras sendo atualizadas em paraleno )
    portfolioResumes = await Future.wait(accounts.map((account) {
      return app().getAccountPortfolioResume(account);
    }));

    updatedPortfoliosAt = DateTime.now();
    updatingPortfolios = false;

    notifyListeners();
  }

  bool isCardOpened(int id) {
    return portfolioCardsOpened[id] == true;
  }

  void toggleCardOpened(int id) {
    portfolioCardsOpened[id] = !(portfolioCardsOpened[id] == true);
    notifyListeners();
  }

  Future<void> refresh() async {
    await updatePortfolios();
  }
}
