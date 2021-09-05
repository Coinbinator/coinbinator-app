// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utils.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exchange _$ExchangeFromJson(Map<String, dynamic> json) {
  return Exchange(
    json['id'],
  );
}

Map<String, dynamic> _$ExchangeToJson(Exchange instance) => <String, dynamic>{
      'id': instance.id,
    };

Coin _$CoinFromJson(Map<String, dynamic> json) {
  return Coin(
    json['symbol'],
  );
}

Map<String, dynamic> _$CoinToJson(Coin instance) => <String, dynamic>{
      'symbol': instance.symbol,
    };

Pair _$PairFromJson(Map<String, dynamic> json) {
  return Pair(
    base: Coin._fromJson(json['base'] as String),
    quote: Coin._fromJson(json['quote'] as String),
  );
}

Map<String, dynamic> _$PairToJson(Pair instance) => <String, dynamic>{
      'base': Coin._toJson(instance.base),
      'quote': Coin._toJson(instance.quote),
    };

Ticker _$TickerFromJson(Map<String, dynamic> json) {
  return Ticker(
    exchange: json['exchange'] == null
        ? null
        : Exchange.fromJson(json['exchange'] as Map<String, dynamic>),
    pair: json['pair'] == null
        ? null
        : Pair.fromJson(json['pair'] as Map<String, dynamic>),
    price: (json['price'] as num)?.toDouble(),
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$TickerToJson(Ticker instance) => <String, dynamic>{
      'exchange': instance.exchange,
      'pair': instance.pair,
      'price': instance.price,
      'date': instance.date?.toIso8601String(),
    };
