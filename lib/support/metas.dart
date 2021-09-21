import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';

final Map<Coin, Set<Coin>> coinAliases = {
  Coins.$USD: {Coins.$USD, Coins.$USDT, Coins.$USDC, Coins.$TUSD},
};

extension Meta on Coin {
  bool get isUSD {
    return coinAliases[Coins.$USD].contains(this);
  }
}
