import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:le_crypto_alerts/metas/accounts/binance_account.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_orders_resume.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_support.dart';
import 'package:le_crypto_alerts/repositories/coinbinator/coinbinator_support.dart';
import 'package:le_crypto_alerts/support/abstract_exchange_repository.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/metas.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:sembast/timestamp.dart';
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
      _socketChannelStreamSubscription = _socketChannel.stream.listen(_socketChannelOnData);

      // _normalTickerFlushTimer = new Timer.periodic(Duration(seconds: 5), _normalTickerFlushData);
    }
  }

  void _socketChannelOnData(event) {
    // Map<String, dynamic> json = value(() {
    //   if (event is String) return jsonDecode(event);
    //   return null;
    // });
    List<CoinbinatorServerMessage> messages = _parseServerMessage(event);
    final eventJson = debugPrint(event);

    return;
    // if (!(eventJson is Iterable)) {
    //   event.toString();
    //   return;
    // }

    // for (final tickerJson in eventJson as Iterable) {
    //   ///NOTE: tentando igno
    //   final pair = _tryConvertStringToPair(tickerJson['s'] as String);
    //   if (!(pair?.quote?.isUSD ?? false)) continue;

    //   final ticker = BinanceWsNormalTicker.fromJson(tickerJson);

    //   if (_normalTickers[pair] == null) {
    //     _normalTickers[pair] = ticker;
    //     continue;
    //   }

    //   _normalTickers[pair].closePrice = ticker.closePrice;
    // }
  }

  void subscribeToTickers(List<Ticker> tickers) {
    debugPrint(jsonEncode({
      "type": "SubscribeToTickers",
      "tickers": tickers.map((ticker) => ticker.key).toList(),
    }));

    _socketChannel.sink.add(jsonEncode({
      "type": "SubscribeToTickers",
      "tickers": tickers.map((ticker) => ticker.key).toList(),
    }));
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

  // void _normalTickerFlushData(Timer timer) {
  //   if (_normalTickers.isEmpty) return;

  //   for (final listener in _tickerListeners) listener(_normalTickers.values.toList());

  //   _normalTickers.clear();
  // }
}
