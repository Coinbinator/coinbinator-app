import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/flutter/provider_urils.dart';
import 'package:provider/provider.dart';

class PortfolioDetailsModel extends ChangeNotifier with ModelUtilMixin {
  final BuildContext context;

  final int accountId;

  bool refreshing = false;

  AbstractExchangeAccount account;

  PortfolioAccountResume portfolioResume;

  DateTime portfolioResumeUpdatedAt;

  bool displaySubAssets = false;

  PortfolioDetailsModel(this.context, this.accountId);

  Future<void> init() async {
    if (status != ModelStatus.UNINITIALIZED) return;
    status = ModelStatus.INITIALIZING;

    await refresh();

    status = ModelStatus.INITIALIZED;
    notifyListeners();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<void> refresh() async {
    final busyToken =
        context.read<LeAppMainProgressIndicatorNotifier>().busyToken();
    refreshing = true;

    account = await app().getAccountById(accountId);

    portfolioResume = await app().getAccountPortfolioResume(account);
    portfolioResumeUpdatedAt = DateTime.now();

    // portfolioTransactions = await app().getAccountPortfolioTransactions(account);

    busyToken.release();
    refreshing = false;
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

  List<Widget> when({
    List<Widget> Function() initialize,
    List<Widget> Function() emptyPorfilio,
    List<Widget> Function() ready,
  }) {
    if (!initialized) {
      return initialize?.call() ?? [];
    }

    if (portfolioResume == null || portfolioResume.coins.isEmpty) {
      return emptyPorfilio?.call() ?? [];
    }

    return ready?.call() ?? [];
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
