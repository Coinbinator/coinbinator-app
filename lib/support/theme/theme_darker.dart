import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/theme/color_schema_tests.dart';
import 'package:le_crypto_alerts/support/theme/theme_common.dart';

extension DarkerThemeData on ThemeData {
  static ThemeData darker() =>
      ThemeData.from(colorScheme: colorSchemaTests()[0])
          .copyWithDark()
          .copyWithCommonThemeData();

  ThemeData copyWithDark() {
    final TextTheme defaultTheme =
        Typography.material2018(platform: defaultTargetPlatform).white;

    Color(0xfff8c36a);

    final textTheme = this.textTheme.copyWith(
          subtitle1: defaultTheme.subtitle1,
          subtitle2: defaultTheme.subtitle2,
        );

    return copyWith(
      unselectedWidgetColor: Colors.red,
      textTheme: textTheme,
    );
  }
}
