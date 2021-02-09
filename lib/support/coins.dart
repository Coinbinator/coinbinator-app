import 'package:le_crypto_alerts/support/codegen/le_coins_annotations.dart';
import 'package:le_crypto_alerts/support/utils.dart';

part 'coins.le.coins.dart';

@LeCoinsAnnotation()
// ignore: unused_element
const _ = null;

Coin _getCoin(String value) {
  return Coins._coins[value];
}

Map<String, Coin> _getAll() {
  return Coins._coins;
}
