import 'package:flutter/foundation.dart';
import 'package:le_crypto_alerts/support/utils.dart';

enum ModelStatus {
  UNINITIALIZED,
  INITIALIZING,
  INITIALIZED,
}

abstract class ModelUtilMixin {
  ModelStatus status = ModelStatus.UNINITIALIZED;

  bool get initialized => ModelStatus.INITIALIZED == status;
}

mixin BusyModel on ChangeNotifier {
  List<dynamic> _busyCalls = [];

  bool get isBusy => _busyCalls.isNotEmpty;

  Future<void> busy(Function future) async {
    _busyCalls.add(future);
    notifyListeners();

    await value(future);

    _busyCalls.remove(future);
    notifyListeners();
  }
}
