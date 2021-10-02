import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_support.dart';

Future<void> _init() async {
  await app().init();
}

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('test getExchangeInfo', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await _init();

      final exchangeInfo = await instance<BinanceRepository>().getExchangeInfo();

      expect(exchangeInfo, isA<BinanceExchangeInformation>());
    });
  });

  testWidgets('test getTickerPrice', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await _init();

      final tickerPrices = await instance<BinanceRepository>().getTickerPrice();

      expect(tickerPrices, isA<List<BinanceTickerPrice>>());
    });
  });

  testWidgets('test getWalletInfo', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await _init();

      final tickerPrices = await instance<BinanceRepository>().getCapitalConfigGetAll();

      expect(tickerPrices, isA<List<BinanceCapitalConfig>>());
    });
  });

  testWidgets('test getAccountOrderHistoryResume', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await _init();
      final account = await app().getAccountById(1);
      final ordersResume = await instance<BinanceRepository>().getAccountOrderHistoryResume(account: account);

      print(ordersResume.orders);
      // expect(exchangeInfo, isA<BinanceExchangeInformation>());
    });
  });
}
