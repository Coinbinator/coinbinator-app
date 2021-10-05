import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';

class PortfolioAccountResume {
  AbstractExchangeAccount account;

  List<PortfolioAccountResumeAsset> coins;

  double get totalBase => coins.map((coin) => coin.baseRate).fold(0, (x, y) => x + y);

  // double get totalUsd => coins.map((coin) => coin.usdRate).fold(0, (x, y) => x + y);

  String get displayName {
    if (account.name == null || account.name.isEmpty) {
      return "Unnamed Portfolio";
    }
    return account.name;
  }
}
