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

    //
    // print("event from app bridge");
    // print(event);
  }

  // ignore: non_constant_identifier_names
  void handleMessage__ticker(TickerMessage message) {
    throw UnimplementedError(
        "Handling of ${MessageTypes.TICKERS} is not completed");
  }

  // ignore: non_constant_identifier_names
  void handleMessage__tickers(TickersMessage message) {
    app().updateTickers(message.tickers ?? []);
  }

  static BackgroundServiceBridge getPlatformBackgroundServiceBridge() {
    /// Mobile
    if (Platform.isAndroid)
      return MobileBackgroundServiceBridge(
          scope: BackgroundServiceBridgeScope.APPLICATION);

    /// Desktop
    if (Platform.isLinux)
      return DesktopBackgroundServiceBridge(
          scope: BackgroundServiceBridgeScope.APPLICATION);

    /// not supported platform
    throw Exception("plataforma nao suportada");
  }
}
