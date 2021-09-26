import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/theme/color_schema_tests.dart';
import 'package:le_crypto_alerts/support/theme/theme_common.dart';

extension DarkerThemeData on ThemeData {
  static final defaultTextThme = ThemeData(fontFamily: 'alpha', brightness: Brightness.dark).textTheme;

  static ThemeData darker() {
    // Creating the base [ThemeData]
    return ThemeData.from(colorScheme: colorSchemaTests()[0], textTheme: defaultTextThme)
        // So apparently [ThemeData.from(colorScheme)] color wont define the [AppBarTheme] and we need to set it forcefully
        .copyWith(
          appBarTheme: AppBarTheme(textTheme: defaultTextThme),
        )
        //
        .copyWithCommonThemeData();
  }
}
