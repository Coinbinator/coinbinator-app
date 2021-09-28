import 'package:flutter_vibrate/flutter_vibrate.dart';

class VibrateRepository {
  Future<bool> get canVibrate async => await Vibrate.canVibrate;

  Future<void> vibrateWithPauses() async {
    if (!(await canVibrate)) return;

    final Iterable<Duration> pauses = [
      const Duration(milliseconds: 300),
      const Duration(milliseconds: 400),
      const Duration(milliseconds: 300),
    ];

    return Vibrate.vibrateWithPauses(pauses);
  }
}
