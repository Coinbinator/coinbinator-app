import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/TickerWatchEntity.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/ticker_watch.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/abstract_app_ticker_listener.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class WatchingPageModel extends ChangeNotifier with AbstractAppTickerListener {
  bool initialized = false;

  final List<TickerWatch> watchingTickers = [];

  final Map<TickerWatch, Ticker> watchingTickerTickers = {};

  WatchingPageModel() {
    app().tickerListeners.add(this);
  }

  Future<void> initialize() async {
    if (this.initialized) return;

    if(app().appDao == null){
      return;
  }

    for (final tickerWatchEntity in await app().appDao.findAllTickerWatches()) {
      watchingTickers.add(TickerWatch(
        exchange: Exchange(tickerWatchEntity.exchange),
        pair: Pair.f2(tickerWatchEntity.base, tickerWatchEntity.quote),

        // pair: Pairs.getPair(
        //   "${tickerWatchEntity.base}${tickerWatchEntity.quote}",
        // ),
      ));
    }

    this.initialized = true;
    notifyListeners();
  }

  FutureOr<void> addTickerWatch(TickerWatch tickerWatch) async {
    //TODO: adicionar suporte ao multiplas exchanges no watch list
    var watchingTicker = watchingTickers.firstWhere((element) => element.pair.eq(tickerWatch.pair), orElse: () => null);

    if (watchingTicker != null) return;

    await app().appDao.insertTickerWatch(TickerWatchEntity(
          tickerWatch.key,
          tickerWatch.exchange.id,
          tickerWatch.pair.base.symbol,
          tickerWatch.pair.quote.symbol,
        ));

    watchingTickers.add(tickerWatch);

    notifyListeners();
  }

  FutureOr<void> removeTickerWatch(TickerWatch tickerWatch) async {
    await app().appDao.deleteTickerWatch(TickerWatchEntity(
          tickerWatch.key,
          null,
          null,
          null,
        ));

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
  FutureOr<void> onTicker(Ticker ticker) async {
    final watchTicker = watchingTickers.firstWhere((element) => element.exchange.id == ticker.exchange.id && element.pair.eq(ticker.pair), orElse: () => null);
    if (watchTicker == null) return;

    watchingTickerTickers[watchTicker] = ticker;
  }
}
