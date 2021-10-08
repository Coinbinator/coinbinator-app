import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/pair.dart';

class PortfolioAccountOrdersResume {
  AbstractExchangeAccount account;

  List<PortfolioAccountOrderResume> orders = [];
}

class PortfolioAccountOrderResume {
  Pair pair;

  dynamic type;

  dynamic status;

  bool filled;

  double quantity;

  double executedQuantity;

  double priceLimit;

  double priceAvg;

  DateTime createdAt;

  DateTime updatedAt;
}
