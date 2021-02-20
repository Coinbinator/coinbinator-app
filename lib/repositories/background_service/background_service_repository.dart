import 'dart:io';

import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/desktop_background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/mobile_background_service_bridge.dart';

class BackgroundServiceRepository {
  DesktopBackgroundServiceBridge _bridge;

  Future<void> initialize() async {
    _bridge = getPlatformBackgroundServiceBridge();
    _bridge.listeners.add(this);

    await _bridge.initialize();
  }

  static getPlatformBackgroundServiceBridge() {
    /// Mobile
    if (Platform.isAndroid) return MobileBackgroundServiceBridge();

    /// Desktop
    if (Platform.isLinux) return DesktopBackgroundServiceBridge();

    /// not supported platform
    throw Exception("plataforma nao suportada");
  }
}
