import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

extension CommonThemeData on ThemeData {
  ThemeData copyWithCommonThemeData() {
    return copyWith(
      /// appBarTheme
      appBarTheme: (appBarTheme ?? AppBarTheme()).copyWith(
        centerTitle: false,
      ),

      /// toggleButtonsTheme
      toggleButtonsTheme: toggleButtonsTheme.copyWith(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),

      unselectedWidgetColor: primaryColor,
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

  S2ChoiceStyle toS2ChoiceStyle() {
    return S2ChoiceStyle(
      // titleStyle: textTheme.headline1, // = const TextStyle(),
      // subtitleStyle: textTheme.headline2, // = const TextStyle(),
      // // // spacing: null,
      // // // runSpacing: null,
      // // // wrapperPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // // // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // // // showCheckmark: null, //,
      // // // control: S2ChoiceControl.platform,
      // // // highlightColor: null, //,
      // // // activeColor: null, //,
      color: Colors.red, //,
      // // // activeAccentColor: null, //,
      // // // accentColor: null, //,
      // activeBrightness: brightness, // = Brightness.light,
      // brightness: brightness, // = Brightness.light,
      // // // activeBorderOpacity: null, //,
      // // // borderOpacity: null, //,
      // // // clipBehavior: null, //,
    );
  }

  S2ModalStyle toS2ModalStyle() {
    return S2ModalStyle(
      // shape: null,
      // elevation: null,
      // backgroundColor: null,
      // clipBehavior: null,
    );
  }
}
