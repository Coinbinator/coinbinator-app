import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

void main() {
  testWidgets('Tests the app_repository', (WidgetTester tester) async {
    expect(app(), app(), reason: "app() deve retornar a mesma insntancia para todas as chamadas");

    await app().loadConfig();

    expect(app().config.test_binance_api_key, env[TEST_BINANCE_API_KEY], reason: "Binance test api key nao foi carregada corretamente");
    expect(app().config.test_binance_api_secret, env[TEST_BINANCE_API_SECRET], reason: 'Binance test api secret nao foi carregado corretamente');

    expect(instance<BinanceRepository>(), isA<BinanceRepository>(), reason: "deveria ser um BinanceRepository");
    expect(instance<BinanceRepository>(), instance<BinanceRepository>(), reason: "BinanceRepository deve ser um singleton");
  });
}
