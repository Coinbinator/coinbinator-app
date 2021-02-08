import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part "utils.g.dart";

enum Exchange {
  NONE,
  BINANCE,
  COINBASE,
}

exchangeToString(Exchange exchange) => _$ExchangeEnumMap[exchange];


@JsonSerializable()
class Pair {
  final Exchange exchange; // Bincance

  final String base; // (BTC)/USDC

  final String quote; // BTC/(USDC)

  Pair({this.exchange, this.base, this.quote}) {
    assert(exchange != null, "pair.exchange nao pode ser null");
    assert(base != null && base.isNotEmpty, "pair.base nao pode estar em branco");
    assert(quote != null && quote.isNotEmpty, "pair.quote nao pode estar em branco");
  }

  get key => "${exchangeToString(exchange)}:$base:$quote";

  get pair => "$base/$quote";

  bool eq(Pair pair) {
    if (exchange != pair.exchange) return false;
    if (base != pair.base) return false;
    if (quote != pair.quote) return false;

    return true;
  }

  Map<String, dynamic> toJson() => _$PairToJson(this);

  static Pair fromJson(json) => _$PairFromJson(json);
}

@JsonSerializable()
class Ticker {
  final Pair pair;
  double price;
  DateTime date;

  Ticker({
    this.pair,
    this.price,
    this.date,
  }) {
    assert(this.pair != null, "ticker.pair nao pode ser null");
    assert(this.price != null, "ticker.price nao pode ser null");
    assert(this.date != null, "ticker.date nao pode ser null");
  }

  Map<String, dynamic> toJson() => _$TickerToJson(this);

  static Ticker fromJson(json) => _$TickerFromJson(json);
}

class ExchangesMeta {
  var pairs = new List<Pair>();
  var tickers = new List<Ticker>();
}

enum ExchangesApiInfoType { BINANCE }

@JsonSerializable()
class BinanceApiAuthInfo {
  final type = ExchangesApiInfoType.BINANCE;
  String name;
  String apiKey;
  String apiSecret;

  BinanceApiAuthInfo({this.name, this.apiKey, this.apiSecret});
}

class Coin {
  final String name;
  final String symbol;

  get key => "$symbol";

  const Coin({this.symbol, this.name});
}

class PortfolioWalletResume {
  String name;
  Map<Coin, double> coins;
}

abstract class E {
  static String currency(value, {String locale, String name, String symbol, int decimalDigits: 2}) {
    final formatter = new NumberFormat.currency(locale: locale, name: name, symbol: symbol, decimalDigits: decimalDigits);

    return formatter.format(value);
  }

  static double toDouble(value) {
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return (value as num).toDouble();
  }
}
