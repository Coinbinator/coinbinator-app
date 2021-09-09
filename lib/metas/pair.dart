import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/support/codegen/le_coins_annotations.dart';

part "pair.g.dart";
part 'pair.le.pairs.dart';

@LePairsAnnotation()
// ignore: unused_element
const _ = null;

@JsonSerializable()
class Pair {
  @JsonKey(toJson: Coin.convertToJson, fromJson: Coin.convertFromJson)
  final Coin base;

  @JsonKey(toJson: Coin.convertToJson, fromJson: Coin.convertFromJson)
  final Coin quote;

  get key => "$base/$quote";

  Coin get baseCoin => base; //Coins.getCoin(base);

  Coin get quoteCoin => quote; //Coins.getCoin(quote);

  Pair.instance({this.base, this.quote}) {
    assert(base != null, "pair.base nao pode ser null");
    assert(quote != null, "pair.quote nao pode ser null");
  }

  factory Pair({dynamic base, dynamic quote}) => Pairs.getPair(Coin(base).symbol + Coin(quote).symbol);

  factory Pair.f1(String value) => Pairs.getPair(value);

  factory Pair.f2(String base, String quote) => Pair(base: Coin(base), quote: Coin(quote));

  bool eq(Pair pair) {
    if (pair == this) return true;
    if (base != pair.base) return false;
    if (quote != pair.quote) return false;
    return true;
  }

  Map<String, dynamic> toJson() => _$PairToJson(this);

  static Pair fromJson(json) => _$PairFromJson(json);

  @override
  String toString() => 'Pair($key)';
}

Pair _getPair(String value) {
  //TODO: mudar essa consulta para suportar a lista sem os alias
  return Pairs._pairs[value?.toUpperCase()];
}

List<Pair> _getAll() {
  //TODO: garantir uma lista unica para nao precisar desse filtro ( deve melhorar performance )
  return Pairs._pairs.values.toSet().toList();
}
