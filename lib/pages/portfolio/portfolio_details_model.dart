import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
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

  bool displaySubAssets = false;

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

  Iterable<PortfolioAccountResumeAsset> getPortifolioMainAssets() {
    //NOTE: no portifolio or assets available
    if (portfolioResume == null || portfolioResume.coins == null) return [];

    return portfolioResume.coins.where((asset) {
      if (!asset.isMainAsset()) return false;

      return true;
    });
  }

  Iterable<PortfolioAccountResumeAsset> getPortifolioSubAssets() {
    //NOTE: no portifolio or assets available
    if (portfolioResume == null || portfolioResume.coins == null) return [];

    return portfolioResume.coins.where((asset) {
      if (!asset.isSubAsset()) return false;

      return true;
    });
  }

  void toggleDisplaySubAssets() {
    displaySubAssets = !displaySubAssets;
    notifyListeners();
  }
}

extension on PortfolioAccountResumeAsset {
  bool isMainAsset() {
    return usdRate >= 10;
  }

  bool isSubAsset() {
    return !isMainAsset();
  }
}
