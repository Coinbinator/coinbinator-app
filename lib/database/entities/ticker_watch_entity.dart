import 'package:floor/floor.dart';

@Entity(tableName: 'ticker_watches')
class TickerWatchEntity {
  @PrimaryKey(autoGenerate: false)
  final String id;

  final String exchange;

  final String base;

  final String quote;

  TickerWatchEntity(
    this.id,
    this.exchange,
    this.base,
    this.quote,
  );
}
