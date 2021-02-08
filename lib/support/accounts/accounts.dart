import 'dart:convert';

abstract class AccountFactory {
  static Account fromPersistence(Map<String, dynamic> value) {
    switch (value["type"]) {
      case Account.BINANCE:
        return new BinanceAccount()
          ..id = value["id"]
          ..name = value["name"]
          ..type = value["type"]
          ..extras = value["extras"]
          ..apiKey = value["apiKey"]
          ..apiSecret = value["apiSecret"];
    }
  }
}

 class Account {
  static const BINANCE = "binance";

  int id;
  String name;
  String type;
  String extras;

  Map<String, dynamic> toPersistence() {
    return {"id": id, "name": name, "type": type, "extras": null};
  }

  T fromPersistence<T extends Account>(Map<String, dynamic> value) {
    return  createList
      ..id = value["id"]
    ..na;
  }
}

class BinanceAccount with Account {
  String apiKey;
  String apiSecret;

  @override
  Map<String, dynamic> toPersistence() {
    return {
      ...super.toPersistence(),
      extras: json.encode({"apiKey": apiKey, "apiSecret": apiSecret})
    };
  }

  @override
  Account fromPersistence(Map<String, > value) {
    // TODO: implement fromPersistence
    return super.fromPersistence(value);
  }
}
