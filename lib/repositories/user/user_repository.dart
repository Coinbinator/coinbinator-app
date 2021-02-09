import 'package:le_crypto_alerts/support/accounts/accounts.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class UserRepository {
  Future<List<Account>> getAccounts() async {
    return [
      BinanceAccount()
        ..name = "Binance Test"
        ..type = Account.BINANCE
        ..apiKey = app().config.test_binance_api_key
        ..apiSecret = app().config.test_binance_api_secret,
    ];
  }
}
