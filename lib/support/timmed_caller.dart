import 'dart:async';

class TimmedCaller {
  Duration _delay;
  Function _action;

  bool _dirty = false;
  DateTime _lastCall;
  Timer _timer;

  TimmedCaller(this._delay, this._action) {
    // _timer = Timer.periodic(_delay, _check);
  }

  void call() {
    if (_lastCall != null && DateTime.now().difference(_lastCall) > _delay) {
      _dirty = true;
      // _timer.
      return;
    }

    _action.call();
    _dirty = false;
    _lastCall = DateTime.now();
  }

  // void _check(_) {

  // }

  void dispose() {
    _delay = null;
    _action = null;

    _timer?.cancel();
    _timer = null;
    _dirty = false;
    _lastCall = null;
  }
}
