import 'dart:io';

import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/desktop_background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/mobile_background_service_bridge.dart';

class BackgroundServiceRepository {
  BackgroundServiceBridge _bridge;

  Future<void> initialize() async {
    _bridge = getPlatformBackgroundServiceBridge()
      ..onDataReceived.listen((event) {
        print("event from app bridge");
        print(event);
      });

    await _bridge.initialize();
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
