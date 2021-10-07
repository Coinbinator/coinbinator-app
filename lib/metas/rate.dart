import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/support/e.dart';

/// Stores the conversion rate between 2 [Coin]s
class Rate {
  final Coin base;

  final Coin quote;

  double price = -1;

  Rate({this.base, this.quote});

  bool has(Coin coin) {
    if (base == coin || quote == coin) return true;
    return false;
  }

  toString() => "Rate(${base.symbol}=>${quote.symbol}) ${E.currencyAlt(price)}";
}
