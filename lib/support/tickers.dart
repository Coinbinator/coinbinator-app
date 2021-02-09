import 'package:le_crypto_alerts/support/utils.dart';

class Tickers {
  final _tickers = List<Ticker>();

  get tickers => _tickers;

  getTicker(Exchange exchange, Pair pair) => _tickers.firstWhere((element) => element.exchange == exchange && element.pair == pair);
}
