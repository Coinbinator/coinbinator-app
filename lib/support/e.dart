import 'package:intl/intl.dart';
import 'package:le_crypto_alerts/support/utils.dart';

abstract class E {
  ///
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

  ///
  static String currencyAlt(value,
      {String locale,
      String name = '\$',
      String symbol,
      int decimalDigits: 2,
      bool forcePositiveSign: false}) {
    // final formatter = new NumberFormat.currency(
    //     locale: locale,
    //     name: name,
    //     symbol: symbol,
    //     decimalDigits: decimalDigits);

    String unitPattern = '';

    if (value >= 1000) {
      value = value / 1000;
      unitPattern = 'k';
    }

    final decimalDigitsPattern =
        (decimalDigits > 0 ? '.' : '') + ('0' * decimalDigits);
    final forcePositiveSignPattern = forcePositiveSign ? "+" : "";
    final formatter = new NumberFormat(
        '$forcePositiveSignPattern#,##0$decimalDigitsPattern$unitPattern;-#,##0$decimalDigitsPattern$unitPattern',
        locale);

    return formatter.format(value);
  }

  static String amountVariationResume(
      {String prefix: '', double amount: 0, double base}) {
    final parts = [
      amount != null ? prefix : null,
      amount != null ? E.currencyAlt(amount) : null,
      amount != null && base != null && base != 0
          ? percentage(amount / base - 1, forcePositiveSign: true)
          : null,
    ];
    return parts
        .where((element) =>
            element != null && (element is String && element.isNotEmpty))
        .join(" ");
  }

  ///
  static double toDouble(value) {
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return (value as num).toDouble();
  }

  ///
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
    final result = base == 0 ? 0 : value / base - 1;

    return percentage(result,
        locale: locale,
        decimalDigits: decimalDigits,
        forcePositiveSign: forcePositiveSign);
  }
}
