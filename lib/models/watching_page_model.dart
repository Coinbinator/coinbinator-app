import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/Persistence.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/pairs.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:sqflite/sqflite.dart';

class WatchingPageModel extends ChangeNotifier with AppTickerListener {
  bool initialized = false;

  final List<TickerWatch> watchingTickers = [];

  final Map<TickerWatch, Ticker> watchingTickerTickers = {};

  WatchingPageModel() {
    app().tickerListeners.add(this);
  }

  Future<void> initialize() async {
    if (this.initialized) return;

    await app().persistence((db) async {
      final tickerWatches = (await db.query(Persistence.WATCHING_TICKERS));
      for (final tickerWatch in tickerWatches) {
        final exchange = Exchanges.getExchange(tickerWatch["exchange"]);
        final pair = Pairs.getPair("${tickerWatch['base']}${tickerWatch['quote']}");
        watchingTickers.add(TickerWatch(exchange: exchange, pair: pair));
      }
      tickerWatches.toString();
    });

    this.initialized = true;
    notifyListeners();
  }

  // void addTicker(Ticker ticker) {
  //   assert(ticker != null, "nao podemos adicionar um ticker nulo");
  //
  //   tickers.add(ticker);
  //
  //   notifyListeners();
  // }

  // void updateTicker(Ticker newTicker) {
  //   assert(newTicker != null, "nao podemos atualizar um ticker nulo");
  //
  //   final ticker = tickers.firstWhere((item) => item.key == newTicker.key, orElse: () => null);
  //   ticker?.price = newTicker.price;
  //   ticker?.date = newTicker.date;
  //
  //   final watchingTicker = watchingTickers.firstWhere((item) => item.key == newTicker.key, orElse: () => null);
  //   watchingTicker?.price = newTicker.price;
  //   watchingTicker?.date = newTicker.date;
  //
  //   notifyListeners();
  // }

  // void updateTickers(List<Ticker> tickers) {
  //   tickers.forEach((ticker) => updateTicker(ticker));
  //
  //   notifyListeners();
  // }

  FutureOr<void> addTickerWatch(TickerWatch tickerWatch) async {
    //TODO: adicionar suporte ao multiplas exchanges no watch list
    var watchingTicker = watchingTickers.firstWhere((element) => element.pair.eq(tickerWatch.pair), orElse: () => null);

    if (watchingTicker != null) {
      return;
    }

    await app().persistence((db) async {
      await db.insert(
          Persistence.WATCHING_TICKERS,
          {
            "id": tickerWatch.key,
            "exchange": tickerWatch.exchange.id,
            "base": tickerWatch.pair.base,
            "quote": tickerWatch.pair.quote,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });

    watchingTickers.add(tickerWatch);

    // watchingTickerTickers[ticker] = app().tickers.getTickerFromWatch(exchange, pair);
    notifyListeners();
  }

  FutureOr<void> removeTickerWatch(TickerWatch tickerWatch) async {
    await app().persistence((db) async {
      await db.delete(
        Persistence.WATCHING_TICKERS,
        where: "id = ?",
        whereArgs: [tickerWatch.key],
      );
    });

    watchingTickers.removeWhere((_tickerWatch) => _tickerWatch.key == tickerWatch.key);
    watchingTickerTickers.remove(tickerWatch);
    notifyListeners();
  }

  @override
  void dispose() {
    app().tickerListeners.remove(this);
    super.dispose();
  }

  @override
  FutureOr<void> onTicker(Ticker ticker) {
    throw UnimplementedError();
  }
}
