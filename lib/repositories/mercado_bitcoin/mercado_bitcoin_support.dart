import 'package:json_annotation/json_annotation.dart';

part 'mercado_bitcoin_support.g.dart';

@JsonSerializable()
class MercadoBitcoinAccountInfo {
  @JsonKey(name: 'response_data')
  MercadoBitcoinAccountResponseData responseData;

  @JsonKey(name: 'status_code')
  int statusCode;

  @JsonKey(name: 'server_unix_timestamp')
  String serverUnixTimestamp;

  static MercadoBitcoinAccountInfo fromJson(json) => _$MercadoBitcoinAccountInfoFromJson(json);
}

@JsonSerializable()
class MercadoBitcoinAccountResponseData {
  @JsonKey(name: 'balance')
  Map<String, MercadoBitcoinAccountBalanceEntry> balance;

  @JsonKey(name: 'withdrawal_limits')
  Map<String, MercadoBitcoinAccountWithdrawalLimitsEntry> withdrawalLimits;

  static MercadoBitcoinAccountResponseData fromJson(json) => _$MercadoBitcoinAccountResponseDataFromJson(json);
}

@JsonSerializable()
class MercadoBitcoinAccountBalanceEntry {
  @JsonKey(name: 'available')
  dynamic available;

  @JsonKey(name: 'total')
  dynamic total;

  @JsonKey(name: 'amount_open_orders', defaultValue: 0)
  dynamic amountOpenOrders;

  static MercadoBitcoinAccountBalanceEntry fromJson(json) => _$MercadoBitcoinAccountBalanceEntryFromJson(json);
}

@JsonSerializable()
class MercadoBitcoinAccountWithdrawalLimitsEntry {
  @JsonKey(name: 'available')
  dynamic available;

  @JsonKey(name: 'total')
  dynamic total;

  static MercadoBitcoinAccountWithdrawalLimitsEntry fromJson(json) => _$MercadoBitcoinAccountWithdrawalLimitsEntryFromJson(json);
}

// @JsonSerializable()
// class MercadoBitcoinAccountBalance {}
