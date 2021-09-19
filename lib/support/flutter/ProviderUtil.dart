import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

enum ModelStatus {
  UNINITIALIZED,
  INITIALIZING,
  INITIALIZED,
}

abstract class ModelUtilMixin {
  ModelStatus status = ModelStatus.UNINITIALIZED;

  bool get initialized => ModelStatus.INITIALIZED == status;
}

extension SafeNotifyListeners on ChangeNotifier {
  void safeNotifyListeners() {
    try {
      // ignore: invalid_use_of_protected_member
      if (hasListeners)
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        notifyListeners();
    } catch (e) {}
  }
}
