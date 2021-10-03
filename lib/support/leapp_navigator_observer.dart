import 'package:flutter/material.dart';

class LeAppNavigatorObserver extends NavigatorObserver {
  List<LeAppNavigatorAware> _listeners = [];

  void subscribe(LeAppNavigatorAware listener) => _listeners.add(listener);
  void unsubscribe(LeAppNavigatorAware listener) => _listeners.remove(listener);

  /// The [Navigator] pushed `route`.
  ///
  /// The route immediately below that one, and thus the previously active
  /// route, is `previousRoute`.
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    didChange(route, previousRoute);
  }

  /// The [Navigator] popped `route`.
  ///
  /// The route immediately below that one, and thus the newly active
  /// rout, is `previousRoute`.
  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    didChange(route, previousRoute);
  }

  void didChange(Route<dynamic> route, Route<dynamic> previousRoute) {
    for (final listener in _listeners) {
      listener.didChange(route, previousRoute);
    }
  }
}

abstract class LeAppNavigatorAware {
  void didChange(Route<dynamic> route, Route<dynamic> previousRoute) {}
}
