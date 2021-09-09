// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pair _$PairFromJson(Map<String, dynamic> json) {
  return Pair(
    base: Coin.convertFromJson(json['base'] as String),
    quote: Coin.convertFromJson(json['quote'] as String),
  );
}

Map<String, dynamic> _$PairToJson(Pair instance) => <String, dynamic>{
      'base': Coin.convertToJson(instance.base),
      'quote': Coin.convertToJson(instance.quote),
    };
