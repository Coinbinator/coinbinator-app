import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_repository.dart';

Future<void> _init() async {
  await app().loadConfig();
}

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('test getExchangeInfo', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await _init();
      final account = await app().getAccountById(2);
      final trades = await instance<MercadoBitcoinRepository>().getAccountTrades(account: account);

      print(trades.responseData.orders);
      // expect(exchangeInfo, isA<BinanceExchangeInformation>());
    });
  });
  //
  // testWidgets('test getTickerPrice', (WidgetTester tester) async {
  //   await tester.runAsync(() async {
  //     await _init();
  //
  //     final tickerPrices = await instance<BinanceRepository>().getTickerPrice();
  //
  //     expect(tickerPrices, isA<List<BinanceTickerPrice>>());
  //   });
  // });
  //
  // testWidgets('test getWalletInfo', (WidgetTester tester) async {
  //   await tester.runAsync(() async {
  //     await _init();
  //
  //     final tickerPrices = await instance<BinanceRepository>().getCapitalConfigGetAll();
  //
  //     expect(tickerPrices, isA<List<BinanceCapitalConfig>>());
  //   });
  // });
}
