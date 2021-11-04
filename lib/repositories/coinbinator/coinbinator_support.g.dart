// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coinbinator_support.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinbinatorTicker _$CoinbinatorTickerFromJson(Map<String, dynamic> json) {
  return CoinbinatorTicker()
    ..key = json['id'] as String
    ..exchange = CoinbinatorUtils.exchangeFromJson(json['exchange'] as String)
    ..pair = CoinbinatorUtils.pairFromJson(json['pair'] as String)
    ..price = json['price'];
}

Map<String, dynamic> _$CoinbinatorTickerToJson(CoinbinatorTicker instance) =>
    <String, dynamic>{
      'id': instance.key,
      'exchange': instance.exchange,
      'pair': instance.pair,
      'price': instance.price,
    };

CoinbinatorTickersServerMessage _$CoinbinatorTickersServerMessageFromJson(
    Map<String, dynamic> json) {
  return CoinbinatorTickersServerMessage()
    ..type = json['type']
    ..tickers = (json['tickers'] as List)
        ?.map((e) => e == null
            ? null
            : CoinbinatorTicker.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CoinbinatorTickersServerMessageToJson(
        CoinbinatorTickersServerMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'tickers': instance.tickers,
    };
