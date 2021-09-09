import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/database/entities/TickerEntity.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';

part 'ticker.g.dart';

@JsonSerializable()
class Ticker {
  final Exchange exchange;
  final Pair pair;
  double price;
  DateTime date;

  String get key => '${exchange.id}:${pair.key}';

  Ticker({
    this.exchange,
    this.pair,
    this.price,
    this.date,
  }) {
    assert(this.pair != null, "ticker.pair nao pode ser null");
    assert(this.price != null, "ticker.price nao pode ser null");
    assert(this.date != null, "ticker.date nao pode ser null");
  }

  Map<String, dynamic> toJson() => _$TickerToJson(this);

  static Ticker fromJson(json) => _$TickerFromJson(json);

  TickerEntity toEntity() => TickerEntity(key, exchange.id, pair.base?.symbol, pair.quote?.symbol, date.millisecondsSinceEpoch, price);

  @override
  String toString() => 'Ticker($key)';
}
