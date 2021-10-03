import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';

@Entity(tableName: 'tickers')
class TickerEntity {
  @PrimaryKey(autoGenerate: false)
  final String id;

  final String exchange;

  final String base;

  final String quote;

  final int updatedAt;

  final double price;

  TickerEntity(
    this.id,
    this.exchange,
    this.base,
    this.quote,
    this.updatedAt,
    this.price,
  );

  factory TickerEntity.fromTicker(Ticker ticker) => ticker == null
      ? null
      : TickerEntity(
          ticker.key,
          ticker.exchange.id,
          ticker.pair.base?.symbol,
          ticker.pair.quote?.symbol,
          ticker.updatedAt.millisecondsSinceEpoch,
          ticker.closePrice,
        );
}
