import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_model.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/flutter/ProviderUtil.dart';
import 'package:provider/provider.dart';

class PortfolioDetailsModel extends ChangeNotifier with ModelUtilMixin {
  final BuildContext context;

  final int accountId;

  bool working = false;

  bool updatingPortfolios = false;

  DateTime updatedPortfoliosAt;

  AbstractExchangeAccount account;

  PortfolioAccountResume portfolioResume;

  PortfolioDetailsModel(this.context, this.accountId);

  Future<void> init() async {
    if (status != ModelStatus.UNINITIALIZED) return;
    status = ModelStatus.INITIALIZING;

    await reloadAccounts();
    await updatePortfolios();

    status = ModelStatus.INITIALIZED;
    notifyListeners();
  }

  Future<void> reloadAccounts() async {
    account = await app().getAccountById(accountId);
    notifyListeners();
  }

  Future<void> updatePortfolios() async {
    final busyToken = context.read<PortfolioModel>().busyToken();
    updatingPortfolios = true;
    notifyListeners();

    portfolioResume = await app().getAccountPortfolioResume(account);
    updatedPortfoliosAt = DateTime.now();
    updatingPortfolios = false;

    // portfolioTransactions =
    await app().getAccountPortfolioTransactions(account);

    busyToken.release();
    notifyListeners();
  }
}
