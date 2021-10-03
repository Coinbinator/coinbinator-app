import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/routes/routes.dart';

Future<void> main() async {
  Intl.defaultLocale = "en_US";
  WidgetsFlutterBinding.ensureInitialized();

  runApp(LeApp());

  Future.microtask(() async {
    await app().init();

    if (MAIN_NAVIGATOR_KEY.currentState != null) {
      // MAIN_NAVIGATOR_KEY.currentState.pushReplacement(getWatchingPageRoute());
      MAIN_NAVIGATOR_KEY.currentState.pushReplacement(getPortfolioListPageRoute());
    }
  });
}
