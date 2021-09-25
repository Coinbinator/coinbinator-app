import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/pages/splash/splash_model.dart';
import 'package:le_crypto_alerts/repositories/alarming/alarming_repository.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/background_service_repository.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  Intl.defaultLocale = "en_US";
  WidgetsFlutterBinding.ensureInitialized();

  runApp(LeApp());

  /// shorhand para atualizacao das mensagens do Splash
  _say(String message) => MAIN_APP_WIDGET?.currentContext?.read<SplashModel>()?.setInitializetionMessage(message);

  Future.microtask(() async {
    _say("Loading configurations...");
    await app().loadConfig();

    _say("Starting internal objects...");
    await instance<AlarmingRepository>().initialize();
    await instance<BackgroundServiceRepository>().initialize();

    _say("Complete.");
    if (MAIN_NAVIGATOR_KEY.currentState != null) {
      MAIN_NAVIGATOR_KEY.currentState.push(getWatchingPageRoute());
    }
  });
}
