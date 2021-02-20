abstract class BackgroundServiceBridge {
  final listeners = List<dynamic>.empty(growable: true);

  Future<void> initialize();

  Future<bool> isServiceRunning() async {
    return true;
  }

  void sendData(Map<String, Object> event) ;
}
