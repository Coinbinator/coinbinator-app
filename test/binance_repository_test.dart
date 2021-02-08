import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_support.dart';

Future<void> _init() async {
  await app().loadConfig();
  final binance = instance<BinanceRepository>();
  binance.apiKey = app().config.test_binance_api_key;
  binance.apiSecret = app().config.test_binance_api_secret;
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



}
