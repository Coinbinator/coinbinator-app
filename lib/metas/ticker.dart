import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/database/entities/ticker_entity.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';

part 'ticker.g.dart';

@JsonSerializable()
class Ticker {
  final Exchange exchange;
  Pair pair;
  double price;
  DateTime updatedAt;

  String get key => '${exchange.id}:${pair.key}';

  Ticker({
    this.exchange,
    this.pair,
    this.price,
    this.updatedAt,
  }) {
    assert(this.pair != null, "pair nao pode ser null");
    assert(this.price != null, "price nao pode ser null");
    // assert(this.updatedAt != null, "updatedAt nao pode ser null");
    if (this.updatedAt == null) this.updatedAt = DateTime.now();
  }

  Map<String, dynamic> toJson() => _$TickerToJson(this);

  static Ticker fromJson(json) => _$TickerFromJson(json);

  @override
  String toString() => 'Ticker($key)';
}
