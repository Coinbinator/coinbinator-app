import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';

class UserRepository {
  Future<List<Account>> getAccounts() async {
    return [
      BinanceAccount()
        ..name = "Binance Test"
        ..apiKey = app().config.test_binance_api_key
        ..apiSecret = app().config.test_binance_api_secret,
    ];
  }
}
