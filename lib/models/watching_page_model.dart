import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class WatchingPageModel extends ChangeNotifier {
  final List<Ticker> tickers = [];

  final List<Ticker> watchingTickers = [];

  void addTicker(Ticker ticker) {
    assert(ticker != null, "nao podemos adicionar um ticker nulo");

    tickers.add(ticker);

    // print(ticker);

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

  void addWatchingTicker(Ticker ticker) {
    if (watchingTickers.firstWhere((element) => element.pair.eq(ticker.pair)) != null) {
      // todo: adicionar um warning "adicionadno watch repetido
      return;
    }

    watchingTickers.add(ticker);
    notifyListeners();
  }
}
