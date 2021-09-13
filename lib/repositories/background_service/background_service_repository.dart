import 'dart:io';

import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/desktop_background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/mobile_background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/messages/messages.dart';

class BackgroundServiceRepository {
  BackgroundServiceBridge _bridge;

  Future<void> initialize() async {
    _bridge = getPlatformBackgroundServiceBridge();
    _bridge.onDataReceived.listen(handleMessage);

    await _bridge.initialize();
  }

  void handleMessage(Map<String, dynamic> event) async {
    final type = event["type"] as String;
    final data = event['data'];

    switch (type) {
      case MessageTypes.TICKER:
        handleMessage__ticker(TickerMessage.fromJson(data));
        return;
      case MessageTypes.TICKERS:
        handleMessage__tickers(TickersMessage.fromJson(data));
        return;
    }
    print("event from app bridge");
    print(event);
  }

  // ignore: non_constant_identifier_names
  void handleMessage__ticker(TickerMessage message) {
    print("handle ticker");
  }

  // ignore: non_constant_identifier_names
  void handleMessage__tickers(TickersMessage message) async {
    print("handle tickers");

    for (final ticker in message.tickers) {
      final staticTicker = app().tickers.getTicker(ticker.exchange, ticker.pair, register: true);
      
      if( staticTicker.pair.eq(Pairs.$BTC_USDT))
        print("$ticker ${(staticTicker.price - ticker.price)} ==> ${staticTicker.price}");

      if (staticTicker.price == ticker.price) continue;
      

      staticTicker.price = ticker.price;
      staticTicker.date = ticker.date;

      app().tickerListeners.forEach((element) => element.onTicker(staticTicker));
    }

    // app().appDao.insertTickers(message.tickers.map((e) => e.toEntity()).toList());
    // print( (await app().appDao.findTickers()) .length );
    print('done');
  }

  static BackgroundServiceBridge getPlatformBackgroundServiceBridge() {
    /// Mobile
    if (Platform.isAndroid) return MobileBackgroundServiceBridge(scope: BackgroundServiceBridgeScope.APPLICATION);

    /// Desktop
    if (Platform.isLinux) return DesktopBackgroundServiceBridge(scope: BackgroundServiceBridgeScope.APPLICATION);

    /// not supported platform
    throw Exception("plataforma nao suportada");
  }
}
