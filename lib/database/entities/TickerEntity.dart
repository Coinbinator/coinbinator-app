import 'package:floor/floor.dart';

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
}
