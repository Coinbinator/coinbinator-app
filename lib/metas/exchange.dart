import 'package:json_annotation/json_annotation.dart';

part 'exchange.g.dart';

@JsonSerializable()
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

  static _getExchange(dynamic value) {
    if (value == null) return null;

    if (value == Binance) return Binance;
    if (value == Binance.id) return Binance;

    if (value == Coinbase) return Coinbase;
    if (value == Coinbase.id) return Coinbase;

    if (value == MercadoBitcoin) return MercadoBitcoin;
    if (value == MercadoBitcoin.id) return MercadoBitcoin;

    throw Exception("Exchange não encontrada: $value}");
  }
}
