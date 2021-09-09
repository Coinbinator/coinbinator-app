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

@JsonSerializable()
class MercadoBitcoinListOrdersResponse {
  @JsonKey(name: 'response_data')
  MercadoBitcoinListOrdersResponseData responseData;

  @JsonKey(name: 'status_code')
  dynamic statusCode;

  @JsonKey(name: 'server_unix_timestamp')
  dynamic serverUnixTimestamp;

  static MercadoBitcoinListOrdersResponse fromJson(json) => _$MercadoBitcoinListOrdersResponseFromJson(json);

  static Map<String, dynamic> toJson(MercadoBitcoinListOrdersResponse instance) => _$MercadoBitcoinListOrdersResponseToJson(instance);
}

@JsonSerializable()
class MercadoBitcoinListOrdersResponseData {
  @JsonKey(name: 'orders')
  List<MercadoBitcoinListOrdersOrder> orders;

  static MercadoBitcoinListOrdersResponseData fromJson(json) => _$MercadoBitcoinListOrdersResponseDataFromJson(json);
}

@JsonSerializable()
class MercadoBitcoinListOrdersOrder {
  @JsonKey(name: 'order_id')
  dynamic orderId;

  @JsonKey(name: 'coin_pair')
  dynamic coinPair;

  @JsonKey(name: 'order_type')
  dynamic orderType;

  @JsonKey(name: 'status')
  dynamic status;

  @JsonKey(name: 'has_fills')
  dynamic hasFills;

  @JsonKey(name: 'quantity')
  dynamic quantity;

  @JsonKey(name: 'limit_price')
  dynamic limitPrice;

  @JsonKey(name: 'executed_quantity')
  dynamic executedQuantity;

  @JsonKey(name: 'executed_price_avg')
  dynamic executedPriceAvg;

  @JsonKey(name: 'fee')
  dynamic fee;

  @JsonKey(name: 'created_timestamp')
  dynamic createdTimestamp;

  @JsonKey(name: 'updated_timestamp')
  dynamic updatedTimestamp;

  @JsonKey(name: 'operations')
  dynamic operations;

  static MercadoBitcoinListOrdersOrder fromJson(json) => _$MercadoBitcoinListOrdersOrderFromJson(json);
}
