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
