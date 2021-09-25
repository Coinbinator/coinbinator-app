import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/background_service_manager.dart';
import 'package:le_crypto_alerts/repositories/background_service/background_service_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/messages/messages.dart';

class MobileBackgroundServiceBridge extends BackgroundServiceBridge {
  static MobileBackgroundServiceBridge instance;

  BackgroundServiceManager _manager;

  bool _initialized = false;

  MobileBackgroundServiceBridge({scope: BackgroundServiceBridgeScope}) : super(scope: scope) {
    if (instance != null) throw Exception("Tentando criar multiplos mobile background managers.");
    instance = this;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    print("(bridge:$scope) initialize");

    /// INITIALIZE application bridge
    if (scope == BackgroundServiceBridgeScope.APPLICATION) {
      await FlutterBackgroundService.initialize(flutterBackgroundService__onStart);
      FlutterBackgroundService()..onDataReceived.listen(flutterBackgroundService__onDataReceived__fromService);
      return;
    }

    /// INITIALIZE service bridge
    if (scope == BackgroundServiceBridgeScope.SERVICE) {
      FlutterBackgroundService()
        ..setForegroundMode(true)
        ..setAutoStartOnBootMode(true)
        ..onDataReceived.listen(flutterBackgroundService__onDataReceived__fromApplication);

      _manager = BackgroundServiceManager(this);
      _manager.start();
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

  bool _mutedTypes(Map<String, dynamic> event) {
    if ([MessageTypes.PING, MessageTypes.PONG, MessageTypes.TICKERS].contains(event['type'])) return true;
    return false;
  }

  void onDataReceivedFromService(Map<String, dynamic> event) {
    if (!_mutedTypes(event)) {
      print("data from serv");
      print(event);
    }

    if (event['type'] == MessageTypes.PING) {
      sendData({"type": MessageTypes.PONG});
    }

    app().instance<BackgroundServiceRepository>().handleMessage(event);
  }

  void onDataReceivedFromApplication(Map<String, dynamic> event) {
    if (!_mutedTypes(event)) {
      print("data from app");
      print(event);
    }

    ///if (event['type'] == MessageTypes.PONG) sendData({"type": "ping pngged"});
  }
}

// ignore: non_constant_identifier_names
void flutterBackgroundService__onStart() async {
  print('Initializing background service');

  WidgetsFlutterBinding.ensureInitialized();

  print('app loading config');
  await app().loadConfig();

  print('creating service bridge');
  final bridge = MobileBackgroundServiceBridge(scope: BackgroundServiceBridgeScope.SERVICE);
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
