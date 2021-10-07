import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
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
    assert(base != null, "pair.base cannot be null");
    assert(quote != null, "pair.quote cannot be null");
  }

  factory Pair({dynamic base, dynamic quote}) => Pairs.getPair(Coin(base).symbol + Coin(quote).symbol);

  bool has(Coin coin) {
    if (base == coin || quote == coin) return true;
    return false;
  }

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

Pair _getPair2(dynamic base, dynamic quote) {
  //NOTE
  // adding support for lists of coins like ( "BTC", ["USD", "USDT", "USDC"])
  if (base is Iterable || quote is Iterable) {
    final itBase = base is Iterable ? base : [base];
    final itQuote = quote is Iterable ? quote : [quote];

    for (final b in itBase) {
      for (final q in itQuote) {
        final pair = _getPair2(b, q);
        if (pair != null) return pair;
      }
    }

    return null;
  }

  return _getPair(Coins.getCoin(base).symbol + Coins.getCoin(quote).symbol);
}

List<Pair> _getAll() {
  //TODO: garantir uma lista de pares unicos para nao precisar desse filtro ( deve melhorar performance )
  return Pairs._pairs.values.toSet().toList();
}
