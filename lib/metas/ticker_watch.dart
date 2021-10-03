import 'package:le_crypto_alerts/database/entities/ticker_watch_entity.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';

class TickerWatch {
  final Exchange exchange;
  final Pair pair;

  String get key => '${exchange.id}:${pair.key}';

  TickerWatch({
    this.exchange,
    this.pair,
  });

  @override
  String toString() => 'TickerWatch($key)';

  factory TickerWatch.fromTickerWatchEntity(TickerWatchEntity tickerWatchEntity) => tickerWatchEntity == null
      ? null
      : TickerWatch(
          exchange: Exchange(tickerWatchEntity.exchange),
          pair: Pairs.getPair2(tickerWatchEntity.base, tickerWatchEntity.quote),
        );
}
