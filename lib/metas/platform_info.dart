import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

/// Source:
/// https://www.flutterclutter.dev/flutter/tutorials/how-to-detect-what-platform-a-flutter-app-is-running-on/2020/127/
class PlatformInfo {
  bool isDesktopOS() {
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  }

  bool isAppOS() {
    return Platform.isMacOS || Platform.isAndroid;
  }

  bool isWeb() {
    return kIsWeb;
  }

  PlatformType getCurrentPlatformType() {
    if (kIsWeb) {
      return PlatformType.Web;
    }

    if (Platform.isMacOS) {
      return PlatformType.MacOS;
    }

    if (Platform.isFuchsia) {
      return PlatformType.Fuchsia;
    }

    if (Platform.isLinux) {
      return PlatformType.Linux;
    }

    if (Platform.isWindows) {
      return PlatformType.Windows;
    }

    if (Platform.isIOS) {
      return PlatformType.iOS;
    }

    if (Platform.isAndroid) {
      return PlatformType.Android;
    }

    return PlatformType.Unknown;
  }
}

enum PlatformType { Web, iOS, Android, MacOS, Fuchsia, Linux, Windows, Unknown }
