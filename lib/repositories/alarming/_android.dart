part of 'alarming_repository.dart';

class _AndroidAlarmingRepository extends AlarmingRepository {
  @override
  Future<void> initialize() async {
    await AndroidAlarmManager.initialize();
  }

  @override
  Future<void> periodic(
    Duration duration,
    int id,
    Function callback, {
    DateTime startAt,
    bool exact = false,
    bool wakeup = false,
    bool rescheduleOnReboot = false,
  }) async {
    return AndroidAlarmManager.periodic(duration, id, callback,
        startAt: startAt,
        wakeup: wakeup,
        rescheduleOnReboot: rescheduleOnReboot);
  }

  @override
  Future<void> oneShot(
    Duration delay,
    int id,
    Function callback, {
    bool alarmClock = false,
    bool allowWhileIdle = false,
    bool exact = false,
    bool wakeup = false,
    bool rescheduleOnReboot = false,
  }) async {
    return AndroidAlarmManager.oneShot(
      delay,
      id,
      callback,
      alarmClock: alarmClock,
      allowWhileIdle: allowWhileIdle,
      exact: exact,
      wakeup: wakeup,
      rescheduleOnReboot: rescheduleOnReboot,
    );
  }
}
