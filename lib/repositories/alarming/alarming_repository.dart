import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';

part '_android.dart';

part '_mock.dart';

abstract class AlarmingRepository {
  Future<void> initialize();

  Future<void> periodic(
    Duration duration,
    int id,
    Function callback, {
    DateTime startAt,
    bool exact = false,
    bool wakeup = false,
    bool rescheduleOnReboot = false,
  });

  static getPlatformRepositoryInstance() {
    /// Android
    if (Platform.isAndroid) return _AndroidAlarmingRepository();

    /// not suported platform
    return _MockAlarmingRepository();
  }
}
