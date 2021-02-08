import 'package:le_crypto_alerts/support/codegen/le_coins.dart';
import 'package:le_crypto_alerts/support/utils.dart';

part 'coins.le.dart';


@LeCoinsAnnotation()
// ignore: unused_element
const _ = null;

Coin _getCoin(String value) {
  return Coins._coins[value];
}
