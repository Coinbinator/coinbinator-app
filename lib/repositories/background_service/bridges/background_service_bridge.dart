import 'dart:async';

enum BackgroundServiceBridgeScope {
  APPLICATION,
  SERVICE,
}

abstract class BackgroundServiceBridge {
  final BackgroundServiceBridgeScope scope;

  final listeners = List<dynamic>.empty(growable: true);

  BackgroundServiceBridge({this.scope});

  Future<void> initialize();

  Future<bool> isServiceRunning() async {
    return true;
  }

  void sendData(Map<String, Object> event);

  final StreamController<Map<String, dynamic>> streamController = StreamController.broadcast();

  Stream<Map<String, dynamic>> get onDataReceived => streamController.stream;

  void dispose() {
    streamController.close();
  }
}
