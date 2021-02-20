part of 'alarming_repository.dart';

class _MockAlarmingRepository extends AlarmingRepository {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> periodic(
    Duration duration,
    int id,
    Function callback, {
    DateTime startAt,
    bool exact = false,
    bool wakeup = false,
    bool rescheduleOnReboot = false,
  }) async {}
}
