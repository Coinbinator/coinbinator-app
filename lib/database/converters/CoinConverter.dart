import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';

class CoinConverter extends TypeConverter<Coin, String> {
  @override
  Coin decode(String databaseValue) {
    return Coins.getCoin(databaseValue);
  }

  @override
  String encode(Coin value) {
    return value?.symbol ?? null;
  }
}
