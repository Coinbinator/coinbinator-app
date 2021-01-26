import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class WatchListModel extends ChangeNotifier {
  final List<Ticker> items = [
    Ticker(pair: Pair(exchange: Exchange.BINANCE, exchangePair: "BTCUSDC", base: "BTC", quote: "USDC"), price: 0),
  ];

  void updateTicker(Ticker ticker) {
    var item = items.firstWhere((item) => item.pair.pair == ticker.pair.pair);

    item?.price = ticker.price;
    item?.date = ticker.date;

    notifyListeners();
  }

  void addTicker(Ticker ticker) {
    items.add(ticker);

    notifyListeners();
  }
}
