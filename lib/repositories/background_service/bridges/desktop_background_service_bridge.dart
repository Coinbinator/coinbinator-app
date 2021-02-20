import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/support/backgrund_service_manager.dart';

class DesktopBackgroundServiceBridge extends BackgroundServiceBridge {
  BackgroundServiceManager manager;

  Future<void> initialize() async {
    this.manager = BackgroundServiceManager(this);
    this.manager.start();
  }

  @override
  void sendData(Map<String, Object> event) {

  }
}
