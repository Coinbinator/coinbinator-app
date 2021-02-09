import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/user/user_repository.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class PortfolioModel extends ChangeNotifier {
  bool initialized = false;
  bool working = false;
  bool updatingPortfolios = false;

  List<Account> accounts = [];

  List<PortfolioWalletResume> walletResumes = [];

  Future<void> initialize() async {
    if (initialized) return;

    await Future.wait([
      reloadAccounts(),
    ]);
    // await Persistence.instance.openx((db) async {
    //   (await db.query(Persistence.WHATCHING_TICKERS))
    //       //
    //       .map((e) => Pair.fromJson(e))
    //       .map((e) => Ticker(pair: e, price: -1, date: DateTime.fromMillisecondsSinceEpoch(0)))
    //       .forEach((ticker) => addWatchingTicker(ticker));
    // });

    this.initialized = true;
    notifyListeners();
  }

  Future<void> reloadAccounts() async {
    accounts = await instance<UserRepository>().getAccounts();
    notifyListeners();
  }

  Future<void> updatePortfolios() async {
    updatingPortfolios = true;
    notifyListeners();

    //TODO: criar alguma forma de batch ( e limitar o numero de carteiras sendo atualizadas em paraleno )
    walletResumes = await Future.wait(accounts.map((account) {
      if (account is BinanceAccount) {
        return instance<BinanceRepository>().getAccountPortfolio(account: account);
      }
      throw Exception("tipo de conta desconhecido");
    }));

    updatingPortfolios = false;
    notifyListeners();
  }
}
