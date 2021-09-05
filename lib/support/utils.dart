import 'dart:async';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/database/entities/TickerEntity.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';
import 'package:le_crypto_alerts/support/coins.dart';
import 'package:le_crypto_alerts/support/pairs.dart';

part "utils.g.dart";

@JsonSerializable()
class Exchange {
  final String id;

  @JsonKey(ignore: true)
  final String name;

  const Exchange._internal({this.id, this.name});

  factory Exchange(id) {
    return Exchanges._getExchange(id);
  }

  Map<String, dynamic> toJson() => _$ExchangeToJson(this);

  static Exchange fromJson(json) => _$ExchangeFromJson(json);

  @override
  String toString() => "Exchange($id)";
}

//TODO: provavelmente vamos remover essa casse e impletar ela somente como factory da "Exchange"
abstract class Exchanges {
  static const Binance = Exchange._internal(id: 'BINANCE', name: "Binance");
  static const Coinbase = Exchange._internal(id: 'COINBASE', name: "Coinbase");
  static const MercadoBitcoin = Exchange._internal(id: "MERCADO_BITCOIN", name: "MercadoBitcoin");

  static _getExchange(dynamic value) {
    if (value == null) return null;

    if (value == Binance) return Binance;
    if (value == Binance.id) return Binance;

    if (value == Coinbase) return Coinbase;
    if (value == Coinbase.id) return Coinbase;

    if (value == MercadoBitcoin) return MercadoBitcoin;
    if (value == MercadoBitcoin.id) return MercadoBitcoin;

    throw Exception("Exchange não encontrada: $value}");
  }
}

@JsonSerializable()
class Coin {
  final String symbol;

  @JsonKey(ignore: true)
  final String name;

  get key => "$symbol";

  const Coin.instance({this.symbol, this.name});

  factory Coin(dynamic symbol) => Coins.getCoin(symbol);

  Map<String, dynamic> toJson() => _$CoinToJson(this);

  static Coin fromJson(json) => _$CoinFromJson(json);

  @override
  String toString() => 'Coin($key)';

  static String _toJson(Coin coin) => coin.symbol;

  static Coin _fromJson(String value) => Coin(value);
}

@JsonSerializable()
class Pair {
  @JsonKey(toJson: Coin._toJson, fromJson: Coin._fromJson)
  final Coin base;

  @JsonKey(toJson: Coin._toJson, fromJson: Coin._fromJson)
  final Coin quote;

  get key => "$base/$quote";

  Coin get baseCoin => base; //Coins.getCoin(base);

  Coin get quoteCoin => quote; //Coins.getCoin(quote);

  Pair.instance({this.base, this.quote}) {
    assert(base != null, "pair.base nao pode ser null");
    assert(quote != null, "pair.quote nao pode ser null");
  }

  factory Pair({dynamic base, dynamic quote}) => Pairs.getPair(Coin(base).symbol + Coin(quote).symbol);

  factory Pair.f1(String value) => Pairs.getPair(value);

  factory Pair.f2(String base, String quote) => Pair(base: Coin(base), quote: Coin(quote));

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

  TickerEntity toEntity() => TickerEntity(key, exchange.id, pair.base?.symbol, pair.quote?.symbol, date.millisecondsSinceEpoch, price);

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

  double get totalUsd => coins.map((coin) => coin.usdRate).fold(0, (x, y) => x + y);
}

class PortfolioWalletCoin {
  Coin coin;
  double amount;
  double btcRate;
  double usdRate;
}

//TODO: remover essa estrutura e utililizar o stremController
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
