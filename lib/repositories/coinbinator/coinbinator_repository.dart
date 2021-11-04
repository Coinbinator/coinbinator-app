import 'dart:async';
import 'dart:convert';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/coinbinator/coinbinator_support.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:web_socket_channel/io.dart';

const COINBINATOR_WEBSOCKET_ENDPOINT = 'ws://127.0.0.1:8000'; //NOTE: temporary

typedef CoinbinatorTickerListener = void Function(List<Ticker>);

class CoinbinatorRepository {
  // Map<Pair, BinanceWsNormalTicker> _normalTickers = {};

  List<CoinbinatorTickerListener> _tickerListeners = [];

  IOWebSocketChannel _socketChannel;

  StreamSubscription _socketChannelStreamSubscription;

  // Timer _normalTickerFlushTimer;

  void listenToTickers(CoinbinatorTickerListener onTickers) {
    _tickerListeners.add(onTickers);

    if (_socketChannel == null) {
      _socketChannel = IOWebSocketChannel.connect(Uri.parse('$COINBINATOR_WEBSOCKET_ENDPOINT/ws/'));
      _socketChannelStreamSubscription = _socketChannel.stream.listen(_handleSocketChannelOnData);

      // _normalTickerFlushTimer = new Timer.periodic(Duration(seconds: 5), _normalTickerFlushData);
    }
  }

  void setTickersSubscriptions(List<Ticker> tickers) {
    // TODO: store ticker list, for socket reconnection handling...

    _socketChannel.sink.add(jsonEncode({
      "type": "SubscribeToTickers",
      "tickers": tickers.map((ticker) => ticker.key).toList(),
    }));
  }

  void _handleSocketChannelOnData(event) {
    List<CoinbinatorServerMessage> messages = _parseServerMessage(event);
    for (final message in messages) {
      if (message is CoinbinatorTickersServerMessage) {
        _handleSocketChannel__TickerServerMessage(message);
        break;
      }
    }
  }

  // ignore: non_constant_identifier_names
  void _handleSocketChannel__TickerServerMessage(CoinbinatorTickersServerMessage message) {
    final tickers = message.tickers.map((t) => Ticker(
          exchange: t.exchange,
          pair: t.pair,
          closePrice: double.tryParse(t.price),
          updatedAt: DateTime.now(),
        ));
    app().updateTickers(tickers);
  }

  List<CoinbinatorServerMessage> _parseServerMessage(dynamic event) {
    dynamic json = value(() {
      if (event is String) return jsonDecode(event);
      return null;
    });

    assert(json != null, 'Unable to parse event');

    List<Map<String, dynamic>> jsonMessages;

    if (json is List) {
      jsonMessages = json;
    }

    if (json is Map<String, dynamic>) {
      jsonMessages = [json];
    }

    assert(jsonMessages is List, 'Unknow json structure');

    List<CoinbinatorServerMessage> messages = jsonMessages.map((jsonMessage) {
      assert(jsonMessage is Map<String, dynamic>);

      switch (jsonMessage['type']) {
        case CoinbinatorServerMessageTypes.tickers:
          return CoinbinatorTickersServerMessage.fromJson(jsonMessage);
      }
    }).toList();

    return messages;
  }
}
