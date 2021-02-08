import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/user/user_repository.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';

class PortfolioModel extends ChangeNotifier {
  bool initialized = false;
  bool working = false;
  List<Account> accounts = [];

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
    //TODO: criar alguma forma de batch ( e limitar o numero de carteiras em paraleno )
    final portfolios = await Future.wait(accounts.map((account) {
      if (account is BinanceAccount) {
        instance<BinanceRepository>().getAccountPortfolio(account);
      }
      throw Exception("tipo de accounr desconhecido");
    }));
  }
}
