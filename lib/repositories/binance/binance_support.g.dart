// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binance_support.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BinanceTickerPrice _$BinanceTickerPriceFromJson(Map<String, dynamic> json) {
  return BinanceTickerPrice(
    json['symbol'] as String,
    json['price'] as String,
  );
}

Map<String, dynamic> _$BinanceTickerPriceToJson(BinanceTickerPrice instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'price': instance.price,
    };

BinanceExchangeInformation _$BinanceExchangeInformationFromJson(
    Map<String, dynamic> json) {
  return BinanceExchangeInformation()
    ..timezone = json['timezone'] as String
    ..serverTime = json['serverTime'] as int
    ..rateLimits = json['rateLimits'] as List
    ..exchangeFilters = json['exchangeFilters'] as List
    ..symbols = (json['symbols'] as List)
        ?.map((e) => e == null
            ? null
            : BinanceExchangeInformationSymbol.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BinanceExchangeInformationToJson(
        BinanceExchangeInformation instance) =>
    <String, dynamic>{
      'timezone': instance.timezone,
      'serverTime': instance.serverTime,
      'rateLimits': instance.rateLimits,
      'exchangeFilters': instance.exchangeFilters,
      'symbols': instance.symbols,
    };

BinanceExchangeInformationSymbol _$BinanceExchangeInformationSymbolFromJson(
    Map<String, dynamic> json) {
  return BinanceExchangeInformationSymbol()
    ..symbol = json['symbol'] as String
    ..status = json['status'] as String
    ..baseAsset = json['baseAsset'] as String
    ..baseAssetPrecision = json['baseAssetPrecision'] as int
    ..quoteAsset = json['quoteAsset'] as String
    ..quotePrecision = json['quotePrecision'] as int
    ..quoteAssetPrecision = json['quoteAssetPrecision'] as int
    ..baseCommissionPrecision = json['baseCommissionPrecision'] as int
    ..quoteCommissionPrecision = json['quoteCommissionPrecision'] as int
    ..orderTypes =
        (json['orderTypes'] as List)?.map((e) => e as String)?.toList()
    ..icebergAllowed = json['icebergAllowed'] as bool
    ..ocoAllowed = json['ocoAllowed'] as bool
    ..quoteOrderQtyMarketAllowed = json['quoteOrderQtyMarketAllowed'] as bool
    ..isSpotTradingAllowed = json['isSpotTradingAllowed'] as bool
    ..isMarginTradingAllowed = json['isMarginTradingAllowed'] as bool
    ..filters = (json['filters'] as List)
        ?.map((e) => e == null
            ? null
            : BinanceExchangeInformationSymbolFilters.fromJson(
                e as Map<String, dynamic>))
        ?.toList()
    ..permissions =
        (json['permissions'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$BinanceExchangeInformationSymbolToJson(
        BinanceExchangeInformationSymbol instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'status': instance.status,
      'baseAsset': instance.baseAsset,
      'baseAssetPrecision': instance.baseAssetPrecision,
      'quoteAsset': instance.quoteAsset,
      'quotePrecision': instance.quotePrecision,
      'quoteAssetPrecision': instance.quoteAssetPrecision,
      'baseCommissionPrecision': instance.baseCommissionPrecision,
      'quoteCommissionPrecision': instance.quoteCommissionPrecision,
      'orderTypes': instance.orderTypes,
      'icebergAllowed': instance.icebergAllowed,
      'ocoAllowed': instance.ocoAllowed,
      'quoteOrderQtyMarketAllowed': instance.quoteOrderQtyMarketAllowed,
      'isSpotTradingAllowed': instance.isSpotTradingAllowed,
      'isMarginTradingAllowed': instance.isMarginTradingAllowed,
      'filters': instance.filters,
      'permissions': instance.permissions,
    };

BinanceExchangeInformationSymbolFilters
    _$BinanceExchangeInformationSymbolFiltersFromJson(
        Map<String, dynamic> json) {
  return BinanceExchangeInformationSymbolFilters()
    ..filterType = json['filterType']
    ..minPrice = json['minPrice']
    ..maxPrice = json['maxPrice']
    ..tickSize = json['tickSize']
    ..multiplierUp = json['multiplierUp']
    ..multiplierDown = json['multiplierDown']
    ..avgPriceMins = json['avgPriceMins']
    ..minQty = json['minQty']
    ..maxQty = json['maxQty']
    ..stepSize = json['stepSize']
    ..minNotional = json['minNotional']
    ..applyToMarket = json['applyToMarket']
    ..limit = json['limit']
    ..maxNumOrders = json['maxNumOrders']
    ..maxNumAlgoOrders = json['maxNumAlgoOrders'];
}

Map<String, dynamic> _$BinanceExchangeInformationSymbolFiltersToJson(
        BinanceExchangeInformationSymbolFilters instance) =>
    <String, dynamic>{
      'filterType': instance.filterType,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'tickSize': instance.tickSize,
      'multiplierUp': instance.multiplierUp,
      'multiplierDown': instance.multiplierDown,
      'avgPriceMins': instance.avgPriceMins,
      'minQty': instance.minQty,
      'maxQty': instance.maxQty,
      'stepSize': instance.stepSize,
      'minNotional': instance.minNotional,
      'applyToMarket': instance.applyToMarket,
      'limit': instance.limit,
      'maxNumOrders': instance.maxNumOrders,
      'maxNumAlgoOrders': instance.maxNumAlgoOrders,
    };

BinanceCapitalConfig _$BinanceCapitalConfigFromJson(Map<String, dynamic> json) {
  return BinanceCapitalConfig()
    ..coin = json['coin'] as String
    ..depositAllEnable = json['depositAllEnable'] as bool
    ..withdrawAllEnable = json['withdrawAllEnable'] as bool
    ..name = json['name'] as String
    ..free = json['free'] as String
    ..locked = json['locked'] as String
    ..freeze = json['freeze'] as String
    ..withdrawing = json['withdrawing'] as String
    ..ipoing = json['ipoing'] as String
    ..ipoable = json['ipoable'] as String
    ..storage = json['storage'] as String
    ..isLegalMoney = json['isLegalMoney'] as bool
    ..trading = json['trading'] as bool
    ..networkList = json['networkList'] as List;
}

Map<String, dynamic> _$BinanceCapitalConfigToJson(
        BinanceCapitalConfig instance) =>
    <String, dynamic>{
      'coin': instance.coin,
      'depositAllEnable': instance.depositAllEnable,
      'withdrawAllEnable': instance.withdrawAllEnable,
      'name': instance.name,
      'free': instance.free,
      'locked': instance.locked,
      'freeze': instance.freeze,
      'withdrawing': instance.withdrawing,
      'ipoing': instance.ipoing,
      'ipoable': instance.ipoable,
      'storage': instance.storage,
      'isLegalMoney': instance.isLegalMoney,
      'trading': instance.trading,
      'networkList': instance.networkList,
    };

BinanceTrade _$BinanceTradeFromJson(Map<String, dynamic> json) {
  return BinanceTrade()
    ..symbol = json['symbol'] as String
    ..id = json['id']
    ..orderId = json['orderId']
    ..orderListId = json['orderListId']
    ..price = double.tryParse(json['price'] as String)
    ..qty = double.tryParse(json['qty'] as String)
    ..quoteQty = double.tryParse(json['quoteQty'] as String)
    ..commission = double.tryParse(json['commission'] as String)
    ..commissionAsset = json['commissionAsset']
    ..time = json['time'] as int
    ..isBuyer = booleanFromJson(json['isBuyer'])
    ..isMaker = booleanFromJson(json['isMaker'])
    ..isBestMatch = booleanFromJson(json['isBestMatch']);
}

Map<String, dynamic> _$BinanceTradeToJson(BinanceTrade instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'id': instance.id,
      'orderId': instance.orderId,
      'orderListId': instance.orderListId,
      'price': instance.price,
      'qty': instance.qty,
      'quoteQty': instance.quoteQty,
      'commission': instance.commission,
      'commissionAsset': instance.commissionAsset,
      'time': instance.time,
      'isBuyer': instance.isBuyer,
      'isMaker': instance.isMaker,
      'isBestMatch': instance.isBestMatch,
    };

BinanceOrder _$BinanceOrderFromJson(Map<String, dynamic> json) {
  return BinanceOrder()
    ..symbol = json['symbol']
    ..orderId = json['orderId'] as int
    ..orderListId = json['orderListId'] as int
    ..clientOrderId = json['clientOrderId']
    ..price = double.tryParse(json['price'] as String)
    ..origQty = double.tryParse(json['origQty'] as String)
    ..executedQty = double.tryParse(json['executedQty'] as String)
    ..cummulativeQuoteQty =
        double.tryParse(json['cummulativeQuoteQty'] as String)
    ..status = json['status'] as String
    ..timeInForce = json['timeInForce'] as String
    ..type = json['type'] as String
    ..side = json['side'] as String
    ..stopPrice = double.tryParse(json['stopPrice'] as String)
    ..icebergQty = double.tryParse(json['icebergQty'] as String)
    ..time = json['time'] as int
    ..updateTime = json['updateTime'] as int
    ..isWorking = json['isWorking'] as bool
    ..origQuoteOrderQty = double.tryParse(json['origQuoteOrderQty'] as String);
}

Map<String, dynamic> _$BinanceOrderToJson(BinanceOrder instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'orderId': instance.orderId,
      'orderListId': instance.orderListId,
      'clientOrderId': instance.clientOrderId,
      'price': instance.price,
      'origQty': instance.origQty,
      'executedQty': instance.executedQty,
      'cummulativeQuoteQty': instance.cummulativeQuoteQty,
      'status': instance.status,
      'timeInForce': instance.timeInForce,
      'type': instance.type,
      'side': instance.side,
      'stopPrice': instance.stopPrice,
      'icebergQty': instance.icebergQty,
      'time': instance.time,
      'updateTime': instance.updateTime,
      'isWorking': instance.isWorking,
      'origQuoteOrderQty': instance.origQuoteOrderQty,
    };
