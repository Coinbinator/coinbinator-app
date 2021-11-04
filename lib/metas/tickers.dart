import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/ticker_watch.dart';
import 'package:le_crypto_alerts/support/metas.dart';

class Tickers {
  final Set<Ticker> _tickers = {};

  get allTickers => _tickers;

  Ticker getTicker(Exchange exchange, Pair pair, {bool createOnMissing: false}) {
    if (exchange == null || pair == null) return null;

    return _tickers.firstWhere(
      (ticker) => ticker.exchange.id == exchange.id && ticker.pair.eq(pair),
      orElse: () => createOnMissing ? _createTicker(exchange, pair) : null,
    );
  }

  Ticker getTickerForTickerWatch(TickerWatch tickerWatch) {
    return getTicker(tickerWatch.exchange, tickerWatch.pair);
  }

  Ticker getTickerForAlertEntity(AlertEntity alertEntity) {
    return getTicker(Exchanges.Binance, Pairs.getPair2(alertEntity.coin, CoinsEx.USD_ALIASES));
  }

  Ticker _createTicker(Exchange exchange, Pair pair) {
    final ticker = Ticker(exchange: exchange, pair: pair, updatedAt: DateTime.now(), closePrice: -1);

    _tickers.add(ticker);

    return ticker;
  }
}
