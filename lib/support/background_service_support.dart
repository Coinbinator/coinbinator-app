import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/support/utils.dart';

part "background_service_support.g.dart";

class MessageTypes {
  static const String TICKER = "TICKER";
}

@JsonSerializable()
class TickerMessage {
  final Ticker ticker;

  TickerMessage(this.ticker);

  Map<String, dynamic> toJson() => _$TickerMessageToJson(this);

  static TickerMessage fromJson(json) => _$TickerMessageFromJson(json);
}
