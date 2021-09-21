import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';

final Map<Coin, Set<Coin>> coinAliases = {
  Coins.$USD: {Coins.$USD, Coins.$USDT, Coins.$USDC, Coins.$TUSD},
};

extension CoinEx on Coin {
  bool get isUSD {
    return coinAliases[Coins.$USD].contains(this);
  }
}

extension CoinsEx on Coins {
  // ignore: non_constant_identifier_names
  static Set<Coin> get USD_ALIASES => coinAliases[Coins.$USD];
}
