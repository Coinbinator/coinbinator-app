import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/TickerWatchEntity.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/pairs.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class WatchingPageModel extends ChangeNotifier with AppTickerListener {
  bool initialized = false;

  final List<TickerWatch> watchingTickers = [];

  final Map<TickerWatch, Ticker> watchingTickerTickers = {};

  WatchingPageModel() {
    app().tickerListeners.add(this);
  }

  Future<void> initialize() async {
    if (this.initialized) return;

    for (final tickerWatchEntity in await app().appDao.findAllTickerWatches()) {
      watchingTickers.add(TickerWatch(
        exchange: Exchanges.getExchange(tickerWatchEntity.exchange),
        pair: Pairs.getPair(
          "${tickerWatchEntity.base}${tickerWatchEntity.quote}",
        ),
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
          tickerWatch.pair.base,
          tickerWatch.pair.quote,
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
  FutureOr<void> onTicker(Ticker ticker) {
    throw UnimplementedError();
  }
}
