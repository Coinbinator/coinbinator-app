import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/repositories/alarming/alarming_repository.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/background_service_repository.dart';

Future<void> main() async {
  Intl.defaultLocale = "en_US";
  WidgetsFlutterBinding.ensureInitialized();

  await app().loadConfig();
  await instance<AlarmingRepository>().initialize();
  await instance<BackgroundServiceRepository>().initialize();

  runApp(app().rootWidget = LeApp());
}
