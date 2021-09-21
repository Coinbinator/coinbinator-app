import 'package:json_annotation/json_annotation.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';

part 'messages.g.dart';

class MessageTypes {
  static const String PING = 'ping';
  static const String PONG = 'pong';
  static const String TICKER = "TICKER";
  static const String TICKERS = "TICKERS";
}

@JsonSerializable()
class TickerMessage {
  final Ticker ticker;

  TickerMessage(this.ticker);

  Map<String, dynamic> toJson() => _$TickerMessageToJson(this);

  static TickerMessage fromJson(json) => _$TickerMessageFromJson(json);
}

@JsonSerializable()
class TickersMessage {
  //TODO: criar um modelo de "dado" mais leve para o "Ticker" ( somente dentro daas mensagens que são compartilhadas entre o app e o bg ) para reduzir custo de memoria
  final List<Ticker> tickers;

  TickersMessage(this.tickers);

  Map<String, dynamic> toJson() => _$TickersMessageToJson(this);

  static TickersMessage fromJson(json) => _$TickersMessageFromJson(json);
}
