// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utils.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pair _$PairFromJson(Map<String, dynamic> json) {
  return Pair(
    exchange: _$enumDecodeNullable(_$ExchangeEnumMap, json['exchange']),
    exchangePair: json['exchangePair'] as String,
    base: json['base'] as String,
    quote: json['quote'] as String,
  );
}

Map<String, dynamic> _$PairToJson(Pair instance) => <String, dynamic>{
      'exchange': _$ExchangeEnumMap[instance.exchange],
      'exchangePair': instance.exchangePair,
      'base': instance.base,
      'quote': instance.quote,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ExchangeEnumMap = {
  Exchange.BINANCE: 'BINANCE',
};

Ticker _$TickerFromJson(Map<String, dynamic> json) {
  return Ticker(
    exchange: _$enumDecodeNullable(_$ExchangeEnumMap, json['exchange']),
    pair: json['pair'] == null
        ? null
        : Pair.fromJson(json['pair'] as Map<String, dynamic>),
    price: (json['price'] as num)?.toDouble(),
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$TickerToJson(Ticker instance) => <String, dynamic>{
      'exchange': _$ExchangeEnumMap[instance.exchange],
      'pair': instance.pair,
      'price': instance.price,
      'date': instance.date?.toIso8601String(),
    };
