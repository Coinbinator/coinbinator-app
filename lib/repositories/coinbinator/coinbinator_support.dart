import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';

part "coinbinator_support.g.dart";

abstract class CoinbinatorUtils {
  /// Converts string to [Pair] static instance
  static Pair pairFromJson(String value) {
    return Pair.createFromString(value, registerIfMissing: true);
  }

  /// Converts string to [Exchange] enum value
  static Exchange exchangeFromJson(String value) {
    return Exchanges.all.firstWhere((element) => element.id == value, orElse: () => null);
  }
}

@JsonSerializable()
class CoinbinatorTicker {
  @JsonKey(name: "id")
  String key;

  @JsonKey(name: "exchange", fromJson: CoinbinatorUtils.exchangeFromJson)
  Exchange exchange;

  @JsonKey(name: "pair", fromJson: CoinbinatorUtils.pairFromJson)
  Pair pair;

  @JsonKey(name: "price")
  String price;

  static CoinbinatorTicker fromJson(json) => _$CoinbinatorTickerFromJson(json);
}

abstract class CoinbinatorServerMessageTypes {
  static const String tickers = 'Tickers';
}

abstract class CoinbinatorServerMessage {
  var type;
}

@JsonSerializable()
class CoinbinatorTickersServerMessage extends CoinbinatorServerMessage {
  var type = CoinbinatorServerMessageTypes.tickers;

  List<CoinbinatorTicker> tickers;

  static CoinbinatorTickersServerMessage fromJson(json) => _$CoinbinatorTickersServerMessageFromJson(json);
}
