import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_repository.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class PortfolioModel extends ChangeNotifier {
  bool initialized = false;

  bool working = false;

  bool updatingPortfolios = false;

  DateTime updatedPortfoliosAt;

  List<Account> accounts = [];

  List<PortfolioWalletResume> portfolioResumes = [];

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
      if (account is BinanceAccount) {
        return instance<BinanceRepository>().getAccountPortfolio(account: account);
      }
      if (account is MercadoBitcoinAccount) {
        return instance<MercadoBitcoinRepository>().getAccountPortfolio(account: account);
      }
      throw Exception("tipo de conta desconhecido");
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
}
