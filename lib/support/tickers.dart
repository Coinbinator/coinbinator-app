import 'package:le_crypto_alerts/support/utils.dart';

class Tickers {
  final _tickers = List<Ticker>();

  get tickers => _tickers;

  getTicker(Exchange exchange, Pair pair, {register: false}) {
    final ticker = _tickers.firstWhere((element) => element.exchange == exchange && element.pair == pair, orElse: () => null);

    if (ticker != null) return ticker;

    if (register == false) return null;

    final newTicker = Ticker(exchange: exchange, pair: pair, date: DateTime.now(), price: -1);

    _tickers.add(newTicker);

    return newTicker;
  }
}
