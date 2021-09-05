import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/support/pairs.dart';
import 'package:le_crypto_alerts/support/utils.dart';

void main() {
  testWidgets('tests utils : exchange classes', (WidgetTester tester) async {
    final exchangeA = Exchange("BINANCE");
    final exchangeB = Exchanges.Binance;

    expect(exchangeA, exchangeB);
  });

  testWidgets('tests utils : pair classes', (WidgetTester tester) async {
    final pair = Pairs.$BTC_USDT;

    print(json.encode(pair));

    final pairB = Pair.fromJson(json.decode(json.encode(pair)));

    print(pairB);

    // expect(pair, exchangeB);
  });
}
