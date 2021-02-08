import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/user/user_repository.dart';

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

  testWidgets('test binance get account portifolio', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await _init();

      final accountPortfolio = await instance<BinanceRepository>().getAccountPortfolio((await instance<UserRepository>().getAccounts())[0]);

      accountPortfolio.toString();
    });
  });
}
