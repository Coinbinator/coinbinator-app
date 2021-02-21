import 'dart:async';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';
import 'package:le_crypto_alerts/support/coins.dart';

part "utils.g.dart";

@JsonSerializable()
class Exchange {
  final String id;

  final String name;

  const Exchange({this.id, this.name});

  Map<String, dynamic> toJson() => _$ExchangeToJson(this);

  static Exchange fromJson(json) => _$ExchangeFromJson(json);

  @override
  String toString() => "Exchange:$id";
}

abstract class Exchanges {
  static const Binance = Exchange(id: 'BINANCE', name: "Binance");
  static const Coinbase = Exchange(id: 'COINBASE', name: "Coinbase");
  static const MercadoBitcoin = Exchange(id: "MERCADO_BITCOIN", name: "MercadoBitcoin");

  static getExchange(dynamic value) {
    if (value == null) return null;

    if (value == Binance.id) return Binance;
    if (value == Coinbase.id) return Coinbase;
    if (value == MercadoBitcoin.id) return MercadoBitcoin;

    throw Exception("Exchange não encontrada: $value}");
  }
}

@JsonSerializable()
class Coin {
  final String name;
  final String symbol;

  get key => "$symbol";

  const Coin({this.symbol, this.name});

  Map<String, dynamic> toJson() => _$CoinToJson(this);

  static Coin fromJson(json) => _$CoinFromJson(json);

  @override
  String toString() => 'Coin($key)';
}

@JsonSerializable()
class Pair {
  final String base;

  final String quote;

  get key => "$base/$quote";

  Coin get baseCoin => Coins.getCoin(base);

  Coin get quoteCoin => Coins.getCoin(quote);

  const Pair({this.base, this.quote});

  bool eq(Pair pair) {
    if (pair == this) return true;
    if (base != pair.base) return false;
    if (quote != pair.quote) return false;
    return true;
  }

  Map<String, dynamic> toJson() => _$PairToJson(this);

  static Pair fromJson(json) => _$PairFromJson(json);

  @override
  String toString() => 'Pair($key)';
}

@JsonSerializable()
class Ticker {
  final Exchange exchange;
  final Pair pair;
  double price;
  DateTime date;

  String get key => '${exchange.id}:${pair.key}';

  Ticker({
    this.exchange,
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

  @override
  String toString() => 'Ticker($key)';
}

class TickerWatch {
  final Exchange exchange;
  final Pair pair;

  String get key => '${exchange.id}:${pair.key}';

  TickerWatch({
    this.exchange,
    this.pair,
  });

  @override
  String toString() => 'TickerWatch($key)';
}

class ExchangesMeta {
  var pairs = new List<Pair>();
  var tickers = new List<Ticker>();
}

// enum ExchangesApiInfoType { BINANCE }

// @JsonSerializable()
// class BinanceApiAuthInfo {
//   final type = ExchangesApiInfoType.BINANCE;
//   String name;
//   String apiKey;
//   String apiSecret;
//
//   BinanceApiAuthInfo({this.name, this.apiKey, this.apiSecret});
// }

class PortfolioWalletResume {
  Account account;

  String name;

  List<PortfolioWalletCoin> coins;

  double get totalUsd => coins.map((e) => e.usdRate).fold(0, (x, y) => x + y);
}

class PortfolioWalletCoin {
  Coin coin;
  double amount;
  double btcRate;
  double usdRate;
}

abstract class AppTickerListener {
  FutureOr<void> onTicker(Ticker ticker);
}

abstract class E {
  static String currency(value, {String locale, String name = '\$', String symbol, int decimalDigits: 2}) {
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

T value<T>(Function() func) {
  return func() as T;
}
