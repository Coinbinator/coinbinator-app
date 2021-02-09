import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/Persistence.dart';
import 'package:le_crypto_alerts/support/pairs.dart';
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
          .map((e) => Ticker(
                exchange: Exchanges.Binance,
                pair: Pairs.getPair(e['base'] + e['quote']),
                price: -1,
                date: DateTime.fromMillisecondsSinceEpoch(0),
              ))
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

    final ticker = tickers.firstWhere((item) => item.key == newTicker.key, orElse: () => null);
    ticker?.price = newTicker.price;
    ticker?.date = newTicker.date;

    final watchingTicker = watchingTickers.firstWhere((item) => item.key == newTicker.key, orElse: () => null);
    watchingTicker?.price = newTicker.price;
    watchingTicker?.date = newTicker.date;

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
      // todo: adicionar um warning "adicionadno watch repetido"
      return;
    }

    await (await Persistence.instance.open()).insert(
        //
        Persistence.WHATCHING_TICKERS,
        {
          "id": ticker.key,
          "exchange": ticker.exchange.id,
          "base": ticker.pair.base,
          "quote": ticker.pair.quote,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);

    watchingTickers.add(ticker);
    working = false;
    notifyListeners();
  }

  FutureOr<void> removeWatchingTicker(Ticker ticker) async {
    await Persistence.instance.openx((db) async {
      await db.delete(
          //
          Persistence.WHATCHING_TICKERS,
          where: "id = ?",
          whereArgs: [ticker.key]);
    });

    watchingTickers.removeWhere((element) => element.key == ticker.key);

    notifyListeners();
  }
}
