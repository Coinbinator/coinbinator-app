import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

Future<void> main() async {
  Intl.defaultLocale = "en_US";
  WidgetsFlutterBinding.ensureInitialized();

  runApp(app().rootWidget = LeApp());
}
