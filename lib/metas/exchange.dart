import 'package:json_annotation/json_annotation.dart';

part 'exchange.g.dart';

@JsonSerializable(createFactory: true)
class Exchange {
  final String id;

  @JsonKey(ignore: true)
  final String name;

  const Exchange._internal({this.id, this.name});

  factory Exchange(id) => Exchanges._getExchange(id);

  Map<String, dynamic> toJson() => _$ExchangeToJson(this);

  static Exchange fromJson(json) => _$ExchangeFromJson(json);

  @override
  String toString() => "Exchange($id)";
}

//TODO: provavelmente vamos remover essa classe e impletar ela somente como factory da "Exchange"
abstract class Exchanges {
  static const Binance = Exchange._internal(id: 'BINANCE', name: "Binance");
  static const Coinbase = Exchange._internal(id: 'COINBASE', name: "Coinbase");
  static const MercadoBitcoin = Exchange._internal(id: "MERCADO_BITCOIN", name: "MercadoBitcoin");

  static const all = [
    Binance,
    Coinbase,
    MercadoBitcoin,
  ];

  static _getExchange(dynamic value) {
    if (value == null) return null;

    for (final exchange in all) {
      if (value == exchange) return exchange;
      if (value == exchange.id) return exchange;
      if (value == exchange.name) return exchange;
    }

    throw Exception('Invalid exchange value: "$value"');
  }
}
