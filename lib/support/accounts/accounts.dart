abstract class AccountTypes {
  static const NONE = null;
  static const BINANCE = "binance";
}

abstract class Account {
  final String type = null;

  int id;
  String name;
  String extras;
}

class BinanceAccount with Account {
  final String type = AccountTypes.BINANCE;

  String apiKey;
  String apiSecret;
}
