import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

class PortfolioAccountResumeAsset {
  Coin coin;
  double amount;
  double btcRate;
  double usdRate;
  double brlRate;

  double get baseRate {
    final baseCoin = app().getBaseCurrency();

    if (baseCoin == Coins.$BRL) return brlRate;

    return usdRate;
  }
}
