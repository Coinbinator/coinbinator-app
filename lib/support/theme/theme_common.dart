import 'package:flutter/material.dart';

extension CommonThemeData on ThemeData {
  ThemeData copyWithCommonThemeData() {
    final dialogTheme = this.dialogTheme.copyWith();

    final toggleButtonsTheme = this.toggleButtonsTheme.copyWith(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        );

    return copyWith(
      dialogTheme: dialogTheme,
      toggleButtonsTheme: toggleButtonsTheme,
    );
  }
}
