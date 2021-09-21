import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/ticker_watch.dart';

class Tickers {
  final _tickers = List<Ticker>.empty(growable: true);

  get tickers => _tickers;

  Ticker getTicker(Exchange exchange, Pair pair, {register: false}) {
    if (exchange == null || pair == null) return null;

    final ticker = _tickers.firstWhere(
        (element) =>
            element.exchange.id == exchange.id && element.pair.eq(pair),
        orElse: () => null);

    if (ticker != null) return ticker;

    if (register == false) return null;

    final newTicker =
        Ticker(exchange: exchange, pair: pair, date: DateTime.now(), price: -1);

    _tickers.add(newTicker);

    return newTicker;
  }

  Ticker getTickerFromTickerWatch(TickerWatch tickerWatch) {
    return getTicker(tickerWatch.exchange, tickerWatch.pair);
  }
}
