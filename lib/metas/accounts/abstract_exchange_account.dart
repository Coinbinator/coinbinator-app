import 'package:le_crypto_alerts/metas/exchange.dart';

int _id = 0;

abstract class AbstractExchangeAccount {
  final String type;

  AbstractExchangeAccount({this.type}) : id = ++_id;

  int id;
  String name;

  Exchange getExchange();
}
