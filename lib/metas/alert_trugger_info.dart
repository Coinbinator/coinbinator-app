import 'package:flutter/foundation.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';

class AlertTriggerInfo {
  final AlertEntity alert;
  final double price;

  AlertTriggerInfo({
    @required this.alert,
    @required this.price,
  });
}
