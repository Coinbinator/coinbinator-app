// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages.dart';

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

TickersMessage _$TickersMessageFromJson(Map<String, dynamic> json) {
  return TickersMessage(
    (json['tickers'] as List)
        ?.map((e) =>
            e == null ? null : Ticker.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TickersMessageToJson(TickersMessage instance) =>
    <String, dynamic>{
      'tickers': instance.tickers,
    };
