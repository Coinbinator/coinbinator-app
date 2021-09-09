import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';

final Map<Coin, Set<Coin>> _coinAliases = {
  Coins.$USD: {Coins.$USD, Coins.$USDT, Coins.$USDC, Coins.$TUSD},
};

class Rate {
  final Coin base;
  final Coin quote;

  double price = -1;

  Rate({this.base, this.quote});
}

class Rates {
  final rates = Set<Rate>();

  void updateRate(Coin base, Coin quote, double price) {
    assert(base != null, "base nao pode ser null");
    assert(quote != null, "quote nao pode ser null");

    final rate = rates.firstWhere((element) => element.base == base && element.quote == quote, orElse: () => null);
    if (rate != null) {
      rate.price = price;
      return;
    }

    final newRate = Rate(base: Coins.getCoin(base.symbol), quote: Coins.getCoin(quote.symbol));
    rates.add(newRate);
    newRate.price = price;
  }

  double getRateFromTo(Coin from, Coin to, {double amount = 1.0}) {
    /// am I a joke?
    if (amount == 0) return 0;

    /// They are the same
    if (from == to) return 1 * amount;

    final fromAlias = _coinAliases[from] ?? {from};
    final toAlias = _coinAliases[to] ?? {to};

    /// They are quite the "same"
    if (fromAlias.intersection(toAlias).isNotEmpty) return 1 * amount;

    /// They have a direct link ( base ==> quote )
    final base0 = rates.firstWhere((rate) => fromAlias.contains(rate.base) && toAlias.contains(rate.quote), orElse: () => null);
    if (base0 != null) {
      return base0.price * amount;
    }

    /// They have a direct link ( quote ==> base  )
    final quote0 = rates.firstWhere((rate) => toAlias.contains(rate.base) && fromAlias.contains(rate.quote), orElse: () => null);
    if (quote0 != null) {
      return (1 / quote0.price) * amount;
    }

    /// We didin't find the connection
    return -1;
  }
}
