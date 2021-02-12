import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/mercado_bitcoin/mercado_bitcoin_repository.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';

Future<void> _init() async {
  await app().loadConfig();
}

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('test binance get account portfolio', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await _init();

      final accountPortfolio = await instance<BinanceRepository>().getAccountPortfolio(account: (await app().getAccounts())[0]);

      accountPortfolio.toString();
    });
  });

  testWidgets('test mercado bitcoin get account portfolio', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await _init();
      final account = (await app().getAccounts()).firstWhere((element) => element is MercadoBitcoinAccount);

      final accountPortfolio = await instance<MercadoBitcoinRepository>().getAccountPortfolio(account: account);

      accountPortfolio.toString();
    });
  });
}
