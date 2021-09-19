// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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