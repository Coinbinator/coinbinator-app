import 'dart:convert';

import 'package:le_crypto_alerts/repositories/background_service/background_service_manager.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';

DesktopBackgroundServiceBridge _applicationBridge;
DesktopBackgroundServiceBridge _serviceBridge;

class DesktopBackgroundServiceBridge extends BackgroundServiceBridge {
  BackgroundServiceManager manager;

  DesktopBackgroundServiceBridge({scope: BackgroundServiceBridgeScope}) : super(scope: scope) {
    if (scope == BackgroundServiceBridgeScope.APPLICATION) {
      _applicationBridge = this;
      _serviceBridge = DesktopBackgroundServiceBridge(scope: BackgroundServiceBridgeScope.SERVICE);
    }
  }

  Future<void> initialize() async {
    this.manager = BackgroundServiceManager(_serviceBridge);
    this.manager.start();
  }

  @override
  void sendData(Map<String, Object> event) {

    /// handle application bridge
    if (scope == BackgroundServiceBridgeScope.APPLICATION) {
      print("data from app");
      print(event);

      manager.onDataReceived(json.decode(json.encode(event)));

      return;
    }

    /// handle service bridge
    if (scope == BackgroundServiceBridgeScope.SERVICE) {
      print("data from serv");
      print(event);

      _applicationBridge.streamController.sink.add(json.decode(json.encode(event)));
      return;
    }
  }
}
