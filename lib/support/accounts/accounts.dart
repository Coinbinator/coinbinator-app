abstract class Account {
  static const BINANCE = "binance";

  int id;
  String name;
  String type;
  String extras;
}

class BinanceAccount with Account {
  String apiKey;
  String apiSecret;
}
