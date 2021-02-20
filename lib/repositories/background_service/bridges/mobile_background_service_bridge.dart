import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/support/backgrund_service_manager.dart';

String _scope;
MobileBackgroundServiceBridge _instance;
BackgroundServiceManager _manager;

class MobileBackgroundServiceBridge extends BackgroundServiceBridge {
  MobileBackgroundServiceBridge() {
    if (_instance != null) throw Exception("Terando criar multiplos mobile background managers.");

    _instance = this;
  }

  Future<void> initialize() async {
    print("MOBILE  initialize");
    _scope = "client";
    await FlutterBackgroundService.initialize(flutterBackgroundService__onStart);
    FlutterBackgroundService().onDataReceived.listen(flutterBackgroundService__onDataReceived);
  }

  @override
  Future<bool> isServiceRunning() async {
    return await FlutterBackgroundService().isServiceRunning();
  }

  onDataReceived(Map<String, dynamic> event) {}

  @override
  void sendData(Map<String, Object> event) {
    FlutterBackgroundService().sendData(event);
  }
}

// ignore: non_constant_identifier_names
void flutterBackgroundService__onStart() {
  if (_scope == null) _scope = "service";

  WidgetsFlutterBinding.ensureInitialized();
  print("($_scope, initializing mobile background service");

  FlutterBackgroundService()
    ..setForegroundMode(true)
    ..setAutoStartOnBootMode(true);
  // ..onDataReceived.listen((event) => _instance.onDataReceived(event));

  _manager = BackgroundServiceManager(_instance);
  _manager.start();
}

// ignore: non_constant_identifier_names
void flutterBackgroundService__onDataReceived(Map<String, dynamic> event) {
  print("($_scope): message received.");
  print(event);
  print('---');

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
}
