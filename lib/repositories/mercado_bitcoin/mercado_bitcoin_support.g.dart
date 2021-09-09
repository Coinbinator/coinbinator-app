// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mercado_bitcoin_support.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MercadoBitcoinAccountInfo _$MercadoBitcoinAccountInfoFromJson(
    Map<String, dynamic> json) {
  return MercadoBitcoinAccountInfo()
    ..responseData = json['response_data'] == null
        ? null
        : MercadoBitcoinAccountResponseData.fromJson(
            json['response_data'] as Map<String, dynamic>)
    ..statusCode = json['status_code'] as int
    ..serverUnixTimestamp = json['server_unix_timestamp'] as String;
}

Map<String, dynamic> _$MercadoBitcoinAccountInfoToJson(
        MercadoBitcoinAccountInfo instance) =>
    <String, dynamic>{
      'response_data': instance.responseData,
      'status_code': instance.statusCode,
      'server_unix_timestamp': instance.serverUnixTimestamp,
    };

MercadoBitcoinAccountResponseData _$MercadoBitcoinAccountResponseDataFromJson(
    Map<String, dynamic> json) {
  return MercadoBitcoinAccountResponseData()
    ..balance = (json['balance'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MercadoBitcoinAccountBalanceEntry.fromJson(
                  e as Map<String, dynamic>)),
    )
    ..withdrawalLimits =
        (json['withdrawal_limits'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MercadoBitcoinAccountWithdrawalLimitsEntry.fromJson(
                  e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$MercadoBitcoinAccountResponseDataToJson(
        MercadoBitcoinAccountResponseData instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'withdrawal_limits': instance.withdrawalLimits,
    };

MercadoBitcoinAccountBalanceEntry _$MercadoBitcoinAccountBalanceEntryFromJson(
    Map<String, dynamic> json) {
  return MercadoBitcoinAccountBalanceEntry()
    ..available = json['available']
    ..total = json['total']
    ..amountOpenOrders = json['amount_open_orders'] ?? 0;
}

Map<String, dynamic> _$MercadoBitcoinAccountBalanceEntryToJson(
        MercadoBitcoinAccountBalanceEntry instance) =>
    <String, dynamic>{
      'available': instance.available,
      'total': instance.total,
      'amount_open_orders': instance.amountOpenOrders,
    };

MercadoBitcoinAccountWithdrawalLimitsEntry
    _$MercadoBitcoinAccountWithdrawalLimitsEntryFromJson(
        Map<String, dynamic> json) {
  return MercadoBitcoinAccountWithdrawalLimitsEntry()
    ..available = json['available']
    ..total = json['total'];
}

Map<String, dynamic> _$MercadoBitcoinAccountWithdrawalLimitsEntryToJson(
        MercadoBitcoinAccountWithdrawalLimitsEntry instance) =>
    <String, dynamic>{
      'available': instance.available,
      'total': instance.total,
    };

MercadoBitcoinListOrdersResponse _$MercadoBitcoinListOrdersResponseFromJson(
    Map<String, dynamic> json) {
  return MercadoBitcoinListOrdersResponse()
    ..responseData = json['response_data'] == null
        ? null
        : MercadoBitcoinListOrdersResponseData.fromJson(
            json['response_data'] as Map<String, dynamic>)
    ..statusCode = json['status_code']
    ..serverUnixTimestamp = json['server_unix_timestamp'];
}

Map<String, dynamic> _$MercadoBitcoinListOrdersResponseToJson(
        MercadoBitcoinListOrdersResponse instance) =>
    <String, dynamic>{
      'response_data': instance.responseData,
      'status_code': instance.statusCode,
      'server_unix_timestamp': instance.serverUnixTimestamp,
    };

MercadoBitcoinListOrdersResponseData
    _$MercadoBitcoinListOrdersResponseDataFromJson(Map<String, dynamic> json) {
  return MercadoBitcoinListOrdersResponseData()
    ..orders = (json['orders'] as List)
        ?.map((e) => e == null
            ? null
            : MercadoBitcoinListOrdersOrder.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$MercadoBitcoinListOrdersResponseDataToJson(
        MercadoBitcoinListOrdersResponseData instance) =>
    <String, dynamic>{
      'orders': instance.orders,
    };

MercadoBitcoinListOrdersOrder _$MercadoBitcoinListOrdersOrderFromJson(
    Map<String, dynamic> json) {
  return MercadoBitcoinListOrdersOrder()
    ..orderId = json['order_id']
    ..coinPair = json['coin_pair']
    ..orderType = json['order_type']
    ..status = json['status']
    ..hasFills = json['has_fills']
    ..quantity = json['quantity']
    ..limitPrice = json['limit_price']
    ..executedQuantity = json['executed_quantity']
    ..executedPriceAvg = json['executed_price_avg']
    ..fee = json['fee']
    ..createdTimestamp = json['created_timestamp']
    ..updatedTimestamp = json['updated_timestamp']
    ..operations = json['operations'];
}

Map<String, dynamic> _$MercadoBitcoinListOrdersOrderToJson(
        MercadoBitcoinListOrdersOrder instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'coin_pair': instance.coinPair,
      'order_type': instance.orderType,
      'status': instance.status,
      'has_fills': instance.hasFills,
      'quantity': instance.quantity,
      'limit_price': instance.limitPrice,
      'executed_quantity': instance.executedQuantity,
      'executed_price_avg': instance.executedPriceAvg,
      'fee': instance.fee,
      'created_timestamp': instance.createdTimestamp,
      'updated_timestamp': instance.updatedTimestamp,
      'operations': instance.operations,
    };
