import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/flutter/provider_urils.dart';

class PortfolioListModel extends ChangeNotifier with ModelUtilMixin, BusyModel {
  bool updatingPortfolios = false;

  DateTime updatedPortfoliosAt;

  List<AbstractExchangeAccount> accounts = [];

  List<PortfolioAccountResume> portfolioResumes = [];

  double get holdingsTotalBaseAmount => portfolioResumes.isEmpty ? 0 : portfolioResumes.map((e) => e.totalBase).reduce((a, b) => a + b);

  // double get holdingsTotalAmount => portfolioResumes.isEmpty ? 0 : portfolioResumes.map((e) => e.totalUsd).reduce((a, b) => a + b);

  Future<void> init() async {
    await busy(() async {
      if (status != ModelStatus.UNINITIALIZED) return;
      status = ModelStatus.INITIALIZING;

      await reloadAccounts();
      await updatePortfolios();

      // final orders = await Future.wait(accounts.map((e) => app().getAccountPortfolioTransactions(e)));
      // orders.toString();

      // print(orders);
      // print(JsonEncoder().convert(orders));

      status = ModelStatus.INITIALIZED;
    });
  }

  Future<void> reloadAccounts() async {
    await busy(() async {
      accounts = await app().getAccounts();
    });
  }

  Future<void> updatePortfolios() async {
    await busy(() async {
      //TODO: limit the number of concurrent accounts updating
      final portfolioResumesFutures = accounts.map((account) => app().getAccountPortfolioResume(account));
      portfolioResumes = await Future.wait(portfolioResumesFutures);

      updatedPortfoliosAt = DateTime.now();
      updatingPortfolios = false;
    });
  }

  Future<void> refresh() async {
    await updatePortfolios();
  }
}
