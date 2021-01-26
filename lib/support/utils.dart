import 'package:json_annotation/json_annotation.dart';

part "utils.g.dart";

enum Exchange {
  BINANCE,
}

@JsonSerializable()
class Pair {
  final Exchange exchange;
  final String exchangePair;

  final String base; // (BTC)/USDC
  final String quote; // BTC/(USDC)

  Pair({this.exchange, this.exchangePair, this.base, this.quote});

  get pair => "$base/$quote";

  Map<String, dynamic> toJson() => _$PairToJson(this);

  static Pair fromJson(json) => _$PairFromJson(json);
}

@JsonSerializable()
class Ticker {
  final Exchange exchange;
  final Pair pair;
  double price;
  DateTime date;

  Ticker({
    this.exchange,
    this.pair,
    this.price,
    this.date,
  });

  Map<String, dynamic> toJson() => _$TickerToJson(this);

  static Ticker fromJson(json) => _$TickerFromJson(json);
}

class ExchangesMeta {
  var pairs = new List<Pair>();
  var tickers = new List<Ticker>();
}
