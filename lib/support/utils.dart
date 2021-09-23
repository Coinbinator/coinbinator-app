// part "utils.g.dart.bkp";

T value<T>(Function() func) {
  return func() as T;
}

class BusyToken {
  final String message;

  Function(BusyToken token) releaseCallback;

  BusyToken(this.releaseCallback, {this.message});

  release() {
    releaseCallback?.call(this);
    releaseCallback = null;
  }
}
