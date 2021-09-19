import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_model.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/flutter/ProviderUtil.dart';
import 'package:provider/provider.dart';

class PortfolioListModel extends ChangeNotifier with ModelUtilMixin {
  final BuildContext context;

  bool updatingPortfolios = false;

  DateTime updatedPortfoliosAt;

  List<AbstractExchangeAccount> accounts = [];

  List<PortfolioAccountResume> portfolioResumes = [];

  PortfolioListModel(this.context);

  Future<void> init() async {
    if (status != ModelStatus.UNINITIALIZED) return;
    status = ModelStatus.INITIALIZING;

    await reloadAccounts();
    await updatePortfolios();

    status = ModelStatus.INITIALIZED;
  }

  Future<void> reloadAccounts() async {
    final busyToken = context.read<PortfolioModel>().busyToken();

    accounts = await app().getAccounts();

    busyToken.release();
    notifyListeners();
  }

  Future<void> updatePortfolios() async {
    final busyToken = context
        .read<PortfolioModel>()
        .busyToken(messagee: "Updating Portifolios");

    updatingPortfolios = true;
    notifyListeners();

    //TODO: criar alguma forma de batch ( e limitar o numero de carteiras sendo atualizadas em paraleno )
    final portifolioResumesFutures =
        accounts.map((account) => app().getAccountPortfolioResume(account));
    portfolioResumes = await Future.wait(portifolioResumesFutures);

    updatedPortfoliosAt = DateTime.now();
    updatingPortfolios = false;
    busyToken.release();
    notifyListeners();
  }

  Future<void> refresh(BuildContext context) async {
    await updatePortfolios();
  }
}
