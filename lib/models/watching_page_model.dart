import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/Persistence.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:sqflite/sqflite.dart';

class WatchingPageModel extends ChangeNotifier {
  bool initialized = false;

  bool working = false;

  final List<Ticker> tickers = [];

  final List<Ticker> watchingTickers = [];

  Future<void> initialize() async {
    await Persistence.instance.openx((db) async {
      (await db.query(Persistence.WHATCHING_TICKERS))
          //
          .map((e) => Pair.fromJson(e))
          .map((e) => Ticker(pair: e, price: -1, date: DateTime.fromMillisecondsSinceEpoch(0)))
          .forEach((ticker) => addWatchingTicker(ticker));
    });

    this.initialized = true;
    notifyListeners();
  }

  void addTicker(Ticker ticker) {
    assert(ticker != null, "nao podemos adicionar um ticker nulo");

    tickers.add(ticker);

    notifyListeners();
  }

  void updateTicker(Ticker newTicker) {
    assert(newTicker != null, "nao podemos atualizar um ticker nulo");

    //note: updating genreal ticker
    () {
      print(newTicker);
      var ticker = tickers.firstWhere((item) => item.pair.pair == newTicker.pair.pair, orElse: () => null);

      if (ticker == null) {
        addTicker(newTicker);
        return;
      }

      ticker.price = newTicker.price;
      ticker.date = newTicker.date;
    }();

    //note: updating watching ticker if any
    () {
      var watchingTicker = watchingTickers.firstWhere((item) => item.pair.pair == newTicker.pair.pair, orElse: () => null);

      if (watchingTicker == null) {
        return;
      }

      watchingTicker.price = newTicker.price;
      watchingTicker.date = newTicker.date;
    }();

    notifyListeners();
  }

  void updateTickers(List<Ticker> tickers) {
    tickers.forEach((ticker) => updateTicker(ticker));

    notifyListeners();
  }

  FutureOr<void> addWatchingTicker(Ticker ticker) async {
    var watchingTicker = watchingTickers.firstWhere(
      (element) => element.pair.eq(ticker.pair),
      orElse: () => null,
    );
    if (watchingTicker != null) {
      // todo: adicionar um warning "adicionadno watch repetido
      return;
    }

    await (await Persistence.instance.open()).insert(
        //
        Persistence.WHATCHING_TICKERS,
        {
          "id": "${ticker.pair.exchange}:${ticker.pair.base}:${ticker.pair.pair}",
          "exchange": exchangeToString(ticker.pair.exchange),
          "base": ticker.pair.base,
          "quote": ticker.pair.quote,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);

    watchingTickers.add(ticker);
    working = false;
    notifyListeners();
  }
}
