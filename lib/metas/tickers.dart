import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/ticker_watch.dart';
import 'package:le_crypto_alerts/support/flutter/dart_utils.dart';
import 'package:le_crypto_alerts/support/metas.dart';

class Tickers {
  final Set<Ticker> _tickers = {};

  get allTickers => _tickers;

  Ticker getTicker(Exchange exchange, Pair pair, {createOnMissing: false}) {
    if (exchange == null || pair == null) return null;

    return _tickers.firstWhere(
      ///NOTE: searching for ticker
      (element) => element.exchange.id == exchange.id && element.pair.eq(pair),

      ///NOTE: didn't find any registered ticker.
      orElse: () {
        if (createOnMissing) {
          final newTicker = Ticker(
            exchange: exchange,
            pair: pair,
            updatedAt: DateTime.now(),
            closePrice: -1,
          );
          _tickers.add(newTicker);
          return newTicker;
        }

        return null;
      },
    );
  }

  Ticker getTickerForTickerWatch(TickerWatch tickerWatch) {
    return getTicker(tickerWatch.exchange, tickerWatch.pair);
  }

  Ticker getTickerForAlertEntity(AlertEntity alertEntity) {
    return getTicker(Exchanges.Binance, Pairs.getPair2(alertEntity.coin, CoinsEx.USD_ALIASES));
  }
}
