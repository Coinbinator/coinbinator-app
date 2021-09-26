import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/theme/color_schema_tests.dart';
import 'package:le_crypto_alerts/support/theme/theme_common.dart';

extension DarkerThemeData on ThemeData {
  static final defaultTextThme = ThemeData(fontFamily: 'alpha', brightness: Brightness.dark).textTheme;

  static ThemeData darker() =>

      /// Creating the base [ThemeData]
      ThemeData.from(colorScheme: colorSchemaTests()[0], textTheme: defaultTextThme)

          /// So apparently [ThemeData.from(colorScheme)] color wont define the [AppBarTheme] and we need to set it manualy
          .copyWith(appBarTheme: AppBarTheme(textTheme: defaultTextThme))

          ///
          .copyWithCommonThemeData();

  ThemeData copyWithDark() {
    // final TextTheme defaultTheme = Typography.material2018(platform: defaultTargetPlatform).white;

    // Color(0xfff8c36a);

    // final textTheme = this.textTheme.copyWith(
    //       subtitle1: defaultTheme.subtitle1,
    //       subtitle2: defaultTheme.subtitle2,
    //     );

    return copyWith(
        // textTheme: textTheme,
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
