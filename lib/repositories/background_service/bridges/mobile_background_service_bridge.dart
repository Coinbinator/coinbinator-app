import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/support/backgrund_service_manager.dart';

enum MobileBackgroundServiceBridgeScope {
  APPLICATION,
  SERVICE,
}

class MobileBackgroundServiceBridge extends BackgroundServiceBridge {
  static MobileBackgroundServiceBridge instance;

  final MobileBackgroundServiceBridgeScope scope;

  BackgroundServiceManager manager;

  MobileBackgroundServiceBridge({this.scope}) {
    if (instance != null) throw Exception("Terando criar multiplos mobile background managers.");
    instance = this;
  }

  Future<void> initialize() async {
    print("(bridge:$scope) initialize");

    /// INITIALIZE application bridge
    if (scope == MobileBackgroundServiceBridgeScope.APPLICATION) {
      await FlutterBackgroundService.initialize(flutterBackgroundService__onStart);
      FlutterBackgroundService()..onDataReceived.listen(flutterBackgroundService__onDataReceived__fromService);
      return;
    }

    /// INITIALIZE service bridge
    if (scope == MobileBackgroundServiceBridgeScope.SERVICE) {
      FlutterBackgroundService()
        ..setForegroundMode(true)
        ..setAutoStartOnBootMode(true)
        ..onDataReceived.listen(flutterBackgroundService__onDataReceived__fromApplication);

      manager = BackgroundServiceManager(this);
      manager.start();
      return;
    }
  }

  @override
  Future<bool> isServiceRunning() async {
    return await FlutterBackgroundService().isServiceRunning();
  }

  @override
  void sendData(Map<String, Object> event) {
    FlutterBackgroundService().sendData(event);
  }

  void onDataReceivedFromService(Map<String, dynamic> event) {
    print("data from serv");
    print(event);

    if (event['type'] == 'ping') sendData({"type": "pong"});
  }

  void onDataReceivedFromApplication(Map<String, dynamic> event) {
    print("data from app");
    print(event);

    if (event['type'] == 'pong') sendData({"type": "ping ponned"});
  }

}

// ignore: non_constant_identifier_names
void flutterBackgroundService__onStart() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bridge = MobileBackgroundServiceBridge(scope: MobileBackgroundServiceBridgeScope.SERVICE);
  await bridge.initialize();
}

// ignore: non_constant_identifier_names
void flutterBackgroundService__onDataReceived__fromApplication(Map<String, dynamic> event) {
  MobileBackgroundServiceBridge.instance.onDataReceivedFromApplication(event);
}

// ignore: non_constant_identifier_names
void flutterBackgroundService__onDataReceived__fromService(Map<String, dynamic> event) {
  MobileBackgroundServiceBridge.instance.onDataReceivedFromService(event);
}
// print("($_scope): message received.");
// print(event);
// print('---');

// /// MessageTypes.TICKER;
// if (event["type"] == MessageTypes.TICKER) {
//   var message = TickerMessage.fromJson(event["data"]);
//   // app().watchListModel.updateTicker(message.ticker);
//   return;
// }
//
// /// <MessageTypes.TICKERS>
// if (event["type"] == MessageTypes.TICKERS) {
//   var message = TickersMessage.fromJson(event["data"]);
//   // app().watchListModel.updateTickers(message.tickers);
//   return;
// }
//
// print("Service message nao processada:");
// print(event);
// }
