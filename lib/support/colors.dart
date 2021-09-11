import 'package:flutter/material.dart';

///
/// https://coolors.co/000000-14213d-fca311-e5e5e5-ffffff
/// https://coolors.co/gradient-palette/fca311-fca311?number=6
///
abstract class LeColors {
  static const _primaryColorInt = 0xff14213D;

  static const MaterialColor primary = MaterialColor(0xff243B6D, <int, Color>{
    50: Color(0xff4365AF),
    100: Color(0xff3D5DA2),
    200: Color(0xff375495),
    300: Color(0xff314C88),
    400: Color(0xff2B447B),
    500: Color(0xff243B6D),
    600: Color(0xff1E3360),
    700: Color(0xff182B53),
    800: Color(0xff122246),
    900: Color(0xff0C1A39),
  });

  static const MaterialColor white = MaterialColor(0xffD5D5D5, <int, Color>{
    50: Color(0xffEFEFEF),
    200: Color(0xffE6E6E6),
    400: Color(0xffDDDDDD),
    500: Color(0xffD5D5D5),
    700: Color(0xffCCCCCC),
    900: Color(0xffC3C3C3),
  });

  static const MaterialColor grey = MaterialColor(0xff8B8B92, <int, Color>{
    50: Color(0xffCBCBD7),
    100: Color(0xffFA72737),
    200: Color(0xffB6B6C0),
    400: Color(0xffA0A0A9),
    500: Color(0xff8B8B92),
    700: Color(0xff75757B),
    900: Color(0xff606064),
  });

  static const MaterialAccentColor accent = MaterialAccentColor(0XFFF1942B, <int, Color>{
    100: Color(0xFFF0AA3A),
    200: Color(0xFFF1942B),
    400: Color(0xFFF17F1C),
    700: Color(0xFFF2690D),
  });

  static const TextStyle t09m = TextStyle(fontSize: 9, color: Color(0xffA0A0A9));
  static const TextStyle t12m = TextStyle(fontSize: 12, color: Color(0xffA0A0A9));
  static const TextStyle t18 = TextStyle(fontSize: 18);
  static const TextStyle t18m = TextStyle(fontSize: 18, color: Color(0xffA0A0A9));
  static const TextStyle t18b = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle t22b = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static const TextStyle t26b = TextStyle(fontSize: 26, fontWeight: FontWeight.bold);


}
