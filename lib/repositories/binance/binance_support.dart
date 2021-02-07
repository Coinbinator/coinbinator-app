import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/support/utils.dart';

part "binance_support.g.dart";

const String BINANCE_API_URL = "https://api.binance.com";

@JsonSerializable()
class BinanceTickerPrice {
  String symbol;
  String price;

  toJson() => _$BinanceTickerPriceToJson(this);

  static BinanceTickerPrice fromJson(json) => _$BinanceTickerPriceFromJson(json);
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

  toJson() => _$BinanceCapitalConfigToJson(this);

  static BinanceCapitalConfig fromJson(json) => _$BinanceCapitalConfigFromJson(json);
}