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
    closePrice: (json['closePrice'] as num)?.toDouble(),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  )
    ..openPrice = (json['openPrice'] as num)?.toDouble()
    ..lowPrice = (json['lowPrice'] as num)?.toDouble()
    ..highPrice = (json['highPrice'] as num)?.toDouble();
}

Map<String, dynamic> _$TickerToJson(Ticker instance) => <String, dynamic>{
      'exchange': instance.exchange,
      'pair': instance.pair,
      'openPrice': instance.openPrice,
      'closePrice': instance.closePrice,
      'lowPrice': instance.lowPrice,
      'highPrice': instance.highPrice,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
