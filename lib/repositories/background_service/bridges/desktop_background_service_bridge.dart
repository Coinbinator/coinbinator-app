import 'dart:convert';

import 'package:le_crypto_alerts/repositories/background_service/background_service_manager.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';

DesktopBackgroundServiceBridge _applicationBridge;
DesktopBackgroundServiceBridge _serviceBridge;
BackgroundServiceManager _manager;

class DesktopBackgroundServiceBridge extends BackgroundServiceBridge {
  DesktopBackgroundServiceBridge({scope: BackgroundServiceBridgeScope}) : super(scope: scope) {
    /// APPLICATION SCOPE
    if (scope == BackgroundServiceBridgeScope.APPLICATION) {
      _applicationBridge = this;
      _serviceBridge = DesktopBackgroundServiceBridge(scope: BackgroundServiceBridgeScope.SERVICE);
    }
  }

  Future<void> initialize() async {
    /// APPLICATION SCOPE
    if (scope == BackgroundServiceBridgeScope.APPLICATION) {
      _manager = BackgroundServiceManager(_serviceBridge);
      _manager.start();
    }
  }

  @override
  void sendData(Map<String, Object> event) {
    //note: precisamos simular o comportamento da bridge mobile
    event = json.decode(json.encode(event));

    /// APPLICATION SCOPE
    if (scope == BackgroundServiceBridgeScope.APPLICATION) {
      //print("data from app");
      //print(event);

      _manager.onDataReceived(event);
      return;
    }

    /// SERVICE SCOPE
    if (scope == BackgroundServiceBridgeScope.SERVICE) {
      // print("data from serv");
      // print(event);
      _applicationBridge.streamController.sink.add(event);
      return;
    }
  }
}
