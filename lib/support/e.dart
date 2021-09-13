import 'package:intl/intl.dart';

abstract class E {
  static String currency(value,
      {String locale,
      String name = '\$',
      String symbol,
      int decimalDigits: 2}) {
    final formatter = new NumberFormat.currency(
        locale: locale,
        name: name,
        symbol: symbol,
        decimalDigits: decimalDigits);

    return formatter.format(value);
  }

  static double toDouble(value) {
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return (value as num).toDouble();
  }

  static String percentage(value,
      {String locale, int decimalDigits: 2, bool forcePositiveSign: false}) {
    if (value == null) {
      return "null%";
    }
    if (value is num) {
      final decimalDigitsPattern =
          (decimalDigits > 0 ? '.' : '') + ('0' * decimalDigits);
      final forcePositiveSignPattern = forcePositiveSign ? "+" : "";
      final formatter = new NumberFormat(
          '$forcePositiveSignPattern#,##0$decimalDigitsPattern%;-#,##0$decimalDigitsPattern%',
          locale);

      return formatter.format(value);
    }

    throw Exception(
        'Unable to convert value to percentage representation, value: "$value"');
  }

  static percentageOf(double value, double base,
      {String locale, int decimalDigits: 2, bool forcePositiveSign: false}) {
    final result = base == 0 ? 0 :  value/ base -1;

    return percentage(result,
        locale: locale,
        decimalDigits: decimalDigits,
        forcePositiveSign: forcePositiveSign);
  }
}
