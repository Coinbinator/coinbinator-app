import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

abstract class AlertsAppContext {
  registerAlert(AlertEntity alert) async {
    await app().appDao.insertAlert(alert);
  }
}
