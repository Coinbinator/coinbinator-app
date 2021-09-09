import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/metas/coins.dart';

part 'coin.g.dart';

@JsonSerializable()
class Coin {
  final String symbol;

  @JsonKey(ignore: true)
  final String name;

  get key => "$symbol";

  const Coin.instance({this.symbol, this.name});

  factory Coin(dynamic symbol) => Coins.getCoin(symbol);

  Map<String, dynamic> toJson() => _$CoinToJson(this);

  static Coin fromJson(json) => _$CoinFromJson(json);

  @override
  String toString() => 'Coin($key)';

  static String convertToJson(Coin coin) => coin.symbol;

  static Coin convertFromJson(String value) => Coin(value);
}
