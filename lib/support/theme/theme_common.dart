import 'package:flutter/material.dart';

extension CommonThemeData on ThemeData {
  ThemeData copyWithTextTheme({
    String fontFamily,
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    Color displayColor,
    Color bodyColor,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
  }) {
    textTheme.apply(
      fontFamily: fontFamily,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      displayColor: displayColor,
      bodyColor: bodyColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
    );
    return copyWith(
      textTheme: textTheme,
    );
  }

  ThemeData copyWithCommonThemeData() {
    final appBarTheme = (this.appBarTheme ?? AppBarTheme()).copyWith(
      centerTitle: false,
      textTheme: (this.appBarTheme.textTheme ?? TextTheme()).copyWith(
        headline1: TextStyle(height: 10.0),
      ),
    );

    final dialogTheme = this.dialogTheme.copyWith();

    final toggleButtonsTheme = this.toggleButtonsTheme.copyWith(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        );

    return copyWith(
      appBarTheme: appBarTheme,
      dialogTheme: dialogTheme,
      toggleButtonsTheme: toggleButtonsTheme,
    );
  }
}
