import 'package:intl/intl.dart';

abstract class E {
  static String currency(value, {String locale, String name = '\$', String symbol, int decimalDigits: 2}) {
    final formatter = new NumberFormat.currency(locale: locale, name: name, symbol: symbol, decimalDigits: decimalDigits);

    return formatter.format(value);
  }

  static double toDouble(value) {
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return (value as num).toDouble();
  }
}
