import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/ticker_watch_entity.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/ticker_watch.dart';
import 'package:le_crypto_alerts/pages/_common/confirm_dialog.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/abstract_app_ticker_listener.dart';
import 'package:le_crypto_alerts/support/metas.dart';

class WatchingPageModel extends ChangeNotifier with AbstractAppTickerListener {
  bool initialized = false;

  List<TickerWatch> watchingTickers = [];

  Map<TickerWatch, Ticker> watchingTickerTickers = {};

  Set<String> selectedTickerWatches = Set<String>();

  Iterable<Pair> get availablePairs {
    return Pairs.getAll().where((pair) {
      if (pair.base.isUSD || pair.quote != Coins.$USDT) return false;
      return true;
    });
  }

  init() async {
    await Future.doWhile(() async {
      if (app().isReady) return false;
      await Future.delayed(Duration(milliseconds: 300));
      return true;
    });

    if (this.initialized) return;
    this.initialized = true;

    app().tickerListeners.add(this);

    for (final tickerWatchEntity in await app().appDao.findAllTickerWatches()) {
      watchingTickers.add(TickerWatch(
        exchange: Exchange(tickerWatchEntity.exchange),
        pair: Pairs.getPair2(tickerWatchEntity.base, tickerWatchEntity.quote),
      ));
    }

    notifyListeners();
  }

  @override
  void dispose() {
    app().tickerListeners.remove(this);
    watchingTickers = null;
    watchingTickerTickers = null;
    selectedTickerWatches = null;
    super.dispose();
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

  bool selectingTickerWatches() {
    if (selectedTickerWatches.length > 0) {
      return true;
    }
    return false;
  }

  bool allTickerWatchesSelected() {
    if (selectedTickerWatches.length == watchingTickers.length) {
      return true;
    }
    return false;
  }

  void selectTickerWatch(TickerWatch tickerWatch) {
    selectedTickerWatches.add(tickerWatch.key);
    notifyListeners();
  }

  void toggleTickerWatch(TickerWatch tickerWatch) {
    if (selectedTickerWatches.contains(tickerWatch.key)) {
      selectedTickerWatches.remove(tickerWatch.key);
      notifyListeners();
      return;
    }
    selectedTickerWatches.add(tickerWatch.key);
    notifyListeners();
  }

  void deselectSelectedTickers() {
    selectedTickerWatches.clear();
    notifyListeners();
  }

  void selectAllTickers() {
    watchingTickers.forEach((tickerWatch) => selectedTickerWatches.add(tickerWatch.key));
    notifyListeners();
  }

  Future<void> deleteSelectedTickers(BuildContext context) async {
    //NOTE: confirmation should be on the widget state
    bool confirm = await askConfirmation(
      context,
      title: Text("Remove ${selectedTickerWatches.length} symbol from wacht list?"),
      // content: Text("Remove ${selectedTickerWatches.length} pairs watches?"),
    );

    if (!confirm) {
      return;
    }

    watchingTickers
        .where((ticker) => selectedTickerWatches.contains(ticker.key))
        .toSet() //note: estava dando um erro de remoção durante iteração (quando removido diretamente apos o where )
        .forEach(
          (ticker) => removeTickerWatch(ticker),
        );

    deselectSelectedTickers();
    notifyListeners();
  }

  // Future<void> startAddTickerWatch(BuildContext context) async {
  //   final selectedPair = await Navigator.of(context).push(new AddWatchModal());
  //   if (selectedPair == null) return;

  //   addTickerWatch(TickerWatch(exchange: Exchanges.Binance, pair: selectedPair));
  //   notifyListeners();
  // }

  @override
  FutureOr<void> onTicker(Ticker ticker) async {
    final watchTicker = watchingTickers.firstWhere((element) => element.exchange.id == ticker.exchange.id && element.pair.eq(ticker.pair), orElse: () => null);

    if (watchTicker == null) return;

    // print("()()()()()()()()()()()()())");

    watchingTickerTickers[watchTicker] = ticker;

    notifyListeners();

    // print("+_+_+_+_+_+_+_+_+_+_+_+_");
  }
}
