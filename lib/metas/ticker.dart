import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker_watch.dart';

part 'ticker.g.dart';

@JsonSerializable()
class Ticker {
  final Exchange exchange;

  Pair pair;

  double openPrice;

  double closePrice;

  double lowPrice;

  double highPrice;

  DateTime updatedAt;

  String get key => '${exchange.id}:${pair.key}';

  Ticker({
    this.exchange,
    this.pair,
    this.closePrice,
    this.updatedAt,
  }) {
    assert(this.pair != null, "pair nao pode ser null");
    assert(this.closePrice != null, "price nao pode ser null");
    // assert(this.updatedAt != null, "updatedAt nao pode ser null");
    if (this.updatedAt == null) this.updatedAt = DateTime.now();
  }

  /// Creates a [Ticker] based on other [Ticker]
  factory Ticker.fromTicker(Ticker ticker) => ticker == null
      ? null
      : Ticker(
          exchange: ticker.exchange,
          pair: ticker.pair,
          closePrice: ticker.closePrice,
          updatedAt: ticker.updatedAt,
        )
    ..openPrice = ticker.openPrice
    ..lowPrice = ticker.lowPrice
    ..highPrice = ticker.highPrice;

  /// Creates a [Ticker] based on other [TickerWatch]
  factory Ticker.fromTickerWatch(TickerWatch tickerWatch) => tickerWatch == null
      ? null
      : Ticker(
          exchange: tickerWatch.exchange,
          pair: tickerWatch.pair,
          closePrice: -1,
          updatedAt: DateTime.now(),
        )
    ..openPrice = -1
    ..lowPrice = -1
    ..highPrice = -1;

  /// Applies the valus of other [Ticker] on this [Ticker]
  void apply(Ticker other) {
    if (other == null) return;
    this
      ..pair = other.pair
      ..openPrice = other.openPrice
      ..closePrice = other.closePrice
      ..lowPrice = other.lowPrice
      ..highPrice = other.highPrice
      ..updatedAt = other.updatedAt;
  }

  /// <true> if other [Ticker] exchange and pair is equal to this [Ticker]
  bool compareExchangeAndPair(Ticker other) {
    return //
        exchange.id == other?.exchange?.id && pair.eq(other.pair);
  }

  /// true if "price" values of other [Ticker] is different from this [Ticker]
  bool hasChanged(Ticker other) {
    return //
        closePrice != other.closePrice || lowPrice != other.lowPrice || highPrice != other.highPrice || openPrice != other.openPrice || pair != other.pair;
  }

  ///
  Map<String, dynamic> toJson() => _$TickerToJson(this);

  ///
  static Ticker fromJson(json) => _$TickerFromJson(json);

  @override
  String toString() => 'Ticker($key)';
}
