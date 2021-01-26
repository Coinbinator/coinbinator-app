// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_service_support.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TickerMessage _$TickerMessageFromJson(Map<String, dynamic> json) {
  return TickerMessage(
    json['ticker'] == null
        ? null
        : Ticker.fromJson(json['ticker'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TickerMessageToJson(TickerMessage instance) =>
    <String, dynamic>{
      'ticker': instance.ticker,
    };
