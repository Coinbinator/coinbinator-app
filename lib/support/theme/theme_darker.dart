import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/theme/color_schema_tests.dart';
import 'package:le_crypto_alerts/support/theme/theme_common.dart';

extension DarkerThemeData on ThemeData {
  static ThemeData darker() => //
      ThemeData.from(colorScheme: colorSchemaTests()[0], textTheme: TextTheme().apply(fontFamily: 'alpha')).copyWithDark().copyWithCommonThemeData();

  ThemeData copyWithDark() {
    final TextTheme defaultTheme = Typography.material2018(platform: defaultTargetPlatform).white;

    Color(0xfff8c36a);

    final textTheme = this.textTheme.copyWith(
          subtitle1: defaultTheme.subtitle1,
          subtitle2: defaultTheme.subtitle2,
        );

    return copyWith(
      textTheme: textTheme,
    );
  }

  /// BuildContext context
  ///   we need the context to call [ElevationOverlay] static methods
  ///
  /// backgroundColor:
  ///   4.0, is the default elevation of [AppBar] "State"
  ///
  ThemeData forDefaultLinearProgressIndicator(BuildContext context) => copyWith(
        backgroundColor: ElevationOverlay.applyOverlay(
          context,
          bottomAppBarColor,
          appBarTheme.elevation ?? 4.0,
        ),
      );
}
