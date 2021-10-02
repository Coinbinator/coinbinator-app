import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/database/entities/ticker_entity.dart';
import 'package:le_crypto_alerts/metas/abstract_mini_ticker.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';

part "binance_support.g.dart";

const String BINANCE_API_URL = "https://api.binance.com";

/// Converts boolish value to real bollean value
bool _booleanFromJson(dynamic value) {
  if (value is num && value == 1) return true;
  if (value is bool && value == true) return true;

  switch (value) {
    case "true":
    case "yes":
    case "1":
      return true;
  }

  return false;
}

/// Converts Binance symbol string to [Pair] static instance
Pair _pairFromJson(String value) {
  return Pairs.getPair(value);
}

@JsonSerializable()
class BinanceTickerPrice {
  final String symbol;
  final String price;

  Pair get lePair => Pairs.getPair(symbol);

  BinanceTickerPrice(this.symbol, this.price);

  toJson() => _$BinanceTickerPriceToJson(this);

  static BinanceTickerPrice fromJson(json) => _$BinanceTickerPriceFromJson(json);

  @override
  String toString() => 'BinanceTickerPrice:$symbol';
}

@JsonSerializable()
class BinanceExchangeInformation {
  String timezone;
  int serverTime;
  List rateLimits;
  List exchangeFilters;
  List<BinanceExchangeInformationSymbol> symbols;

  toJson() => _$BinanceExchangeInformationToJson(this);

  static BinanceExchangeInformation fromJson(json) => _$BinanceExchangeInformationFromJson(json);
}

@JsonSerializable()
class BinanceExchangeInformationSymbol {
  String symbol; //": "ETHBTC",
  String status; //": "TRADING",
  String baseAsset; //": "ETH",
  int baseAssetPrecision; //": 8,
  String quoteAsset; //": "BTC",
  int quotePrecision; //": 8,
  int quoteAssetPrecision; //": 8,
  int baseCommissionPrecision;
  int quoteCommissionPrecision;
  List<String> orderTypes; //": [ ],
  bool icebergAllowed; //": true,
  bool ocoAllowed; //": true,
  bool quoteOrderQtyMarketAllowed;
  bool isSpotTradingAllowed; //": true,
  bool isMarginTradingAllowed; //": true,
  List<BinanceExchangeInformationSymbolFilters> filters; //": [ ],
  List<String> permissions; //": [ ]

  Pair get lePair => Pairs.getPair(symbol);

  toJson() => _$BinanceExchangeInformationSymbolToJson(this);

  static BinanceExchangeInformationSymbol fromJson(json) => _$BinanceExchangeInformationSymbolFromJson(json);
}

@JsonSerializable()
class BinanceExchangeInformationSymbolFilters {
  dynamic filterType;
  dynamic minPrice;
  dynamic maxPrice;
  dynamic tickSize;
  dynamic multiplierUp;
  dynamic multiplierDown;
  dynamic avgPriceMins;
  dynamic minQty;
  dynamic maxQty;
  dynamic stepSize;
  dynamic minNotional;
  dynamic applyToMarket;
  dynamic limit;
  dynamic maxNumOrders;
  dynamic maxNumAlgoOrders;

  toJson() => _$BinanceExchangeInformationSymbolFiltersToJson(this);

  static BinanceExchangeInformationSymbolFilters fromJson(json) => _$BinanceExchangeInformationSymbolFiltersFromJson(json);
}

@JsonSerializable()
class BinanceCapitalConfig {
  String coin;
  bool depositAllEnable;
  bool withdrawAllEnable;
  String name;
  String free;
  String locked;
  String freeze;
  String withdrawing;
  String ipoing;
  String ipoable;
  String storage;
  bool isLegalMoney;
  bool trading;
  List networkList;

  Coin get leCoin => Coins.getCoin(coin);

  toJson() => _$BinanceCapitalConfigToJson(this);

  static BinanceCapitalConfig fromJson(json) => _$BinanceCapitalConfigFromJson(json);
}

@JsonSerializable()
class BinanceTrade {
  @JsonKey(name: "symbol")
  String symbol;

  @JsonKey(name: "id")
  dynamic id;

  @JsonKey(name: "orderId")
  dynamic orderId;

  @JsonKey(name: "orderListId")
  dynamic orderListId;

  @JsonKey(name: "price", fromJson: double.tryParse)
  double price;

  @JsonKey(name: "qty", fromJson: double.tryParse)
  double qty;

  @JsonKey(name: "quoteQty", fromJson: double.tryParse)
  double quoteQty;

  @JsonKey(name: "commission", fromJson: double.tryParse)
  double commission;

  @JsonKey(name: "commissionAsset")
  dynamic commissionAsset;

  @JsonKey(name: "time")
  int time;

  @JsonKey(name: "isBuyer", fromJson: _booleanFromJson)
  bool isBuyer;

  @JsonKey(name: "isMaker", fromJson: _booleanFromJson)
  bool isMaker;

  @JsonKey(name: "isBestMatch", fromJson: _booleanFromJson)
  bool isBestMatch;

  static BinanceTrade fromJson(json) => _$BinanceTradeFromJson(json);
}

@JsonSerializable()
class BinanceOrder {
  @JsonKey(name: "symbol")
  dynamic symbol;

  @JsonKey(name: "orderId")
  int orderId;

  @JsonKey(name: "orderListId")
  int orderListId;

  @JsonKey(name: "clientOrderId")
  dynamic clientOrderId;

  @JsonKey(name: "price", fromJson: double.tryParse)
  double price;

  @JsonKey(name: "origQty", fromJson: double.tryParse)
  double origQty;

  @JsonKey(name: "executedQty", fromJson: double.tryParse)
  double executedQty;

  @JsonKey(name: "cummulativeQuoteQty", fromJson: double.tryParse)
  double cummulativeQuoteQty;

  @JsonKey(name: "status")
  String status;

  @JsonKey(name: "timeInForce")
  String timeInForce;

  @JsonKey(name: "type")
  String type;

  @JsonKey(name: "side")
  String side;

  @JsonKey(name: "stopPrice", fromJson: double.tryParse)
  double stopPrice;

  @JsonKey(name: "icebergQty", fromJson: double.tryParse)
  double icebergQty;

  @JsonKey(name: "time")
  int time;

  @JsonKey(name: "updateTime")
  int updateTime;

  @JsonKey(name: "isWorking")
  bool isWorking;

  @JsonKey(name: "origQuoteOrderQty", fromJson: double.tryParse)
  double origQuoteOrderQty;

  static BinanceOrder fromJson(json) => _$BinanceOrderFromJson(json);
}

@JsonSerializable()
class BinanceWs24hrTicker {
  @JsonKey(name: "e")
  var eventType;

  @JsonKey(name: "E")
  var eventTime;

  @JsonKey(name: "s", fromJson: _pairFromJson)
  Pair symbol;

  @JsonKey(name: "p")
  var pricechange;

  @JsonKey(name: "P")
  var priceChangePercent;

  @JsonKey(name: "w")
  var weightedAveragePrice;

  @JsonKey(name: "x")
  var firstTrade;

  @JsonKey(name: "c")
  var lastPrice;

  @JsonKey(name: "Q")
  var lastQuantity;

  @JsonKey(name: "b")
  var bestBidPrice;

  @JsonKey(name: "B")
  var bestBidQuantity;

  @JsonKey(name: "a")
  var bestAskPrice;

  @JsonKey(name: "A")
  var bestAskQuantity;

  @JsonKey(name: "o")
  var openPrice;

  @JsonKey(name: "h")
  var highPrice;

  @JsonKey(name: "l")
  var lowPrice;

  @JsonKey(name: "v")
  var totalTradedBaseAssetVolume;

  @JsonKey(name: "q")
  var totalTradedQuoteAssetBolume;

  @JsonKey(name: "O")
  var statisticsOpenTime;

  @JsonKey(name: "C")
  var statisticsCloseTime;

  @JsonKey(name: "F")
  var firstTradeId;

  @JsonKey(name: "L")
  var lastTradeId;

  @JsonKey(name: "n")
  var totalNumberOfTrades;

  static BinanceWs24hrTicker fromJson(json) => _$BinanceWs24hrTickerFromJson(json);
}

// @JsonSerializable()
// class BinanceWsMiniTicker implements MiniTicker {
//   @override
//   @JsonKey(name: "c", fromJson: double.tryParse)
//   double lastPrice;

//   @override
//   @JsonKey(name: "s", fromJson: _pairFromJson)
//   Pair pair;

//   static BinanceWsMiniTicker fromJson(json) => _$BinanceWsMiniTickerFromJson(json);
// }

@JsonSerializable()
class BinanceWsNormalTicker extends Ticker {
  @override
  @JsonKey(ignore: true)
  Exchange exchange = Exchanges.Binance;

  @override
  @JsonKey(name: "s", fromJson: _pairFromJson)
  Pair pair;

  @override
  @JsonKey(name: "c", fromJson: double.tryParse)
  double price;

  BinanceWsNormalTicker({
    this.exchange = Exchanges.Binance,
    this.pair,
    this.price,
    updatedAt,
  }) : super(updatedAt: updatedAt);

  static BinanceWsNormalTicker fromJson(json) => _$BinanceWsNormalTickerFromJson(json);
}
