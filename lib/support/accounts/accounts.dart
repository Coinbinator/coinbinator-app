abstract class AccountTypes {
  static const NONE = null;
  static const BINANCE = "binance";
  static const MERCADO_BITCOIN = "mercado_bitcoin";
}

int _ID = 0;

abstract class Account {
  final String type;

  Account({this.type}) {
    id = ++_ID;
  }

  int id;
  String name;
}

class BinanceAccount extends Account {
  BinanceAccount() : super(type: AccountTypes.BINANCE);

  String apiKey;
  String apiSecret;
}

class MercadoBitcoinAccount extends Account {
  MercadoBitcoinAccount() : super(type: AccountTypes.MERCADO_BITCOIN);

  String tapiId;
  String tapiSecret;
}
