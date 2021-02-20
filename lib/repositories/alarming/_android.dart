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
    return AndroidAlarmManager.periodic(duration, id, callback, startAt: startAt, wakeup: wakeup, rescheduleOnReboot: rescheduleOnReboot);
  }
}
