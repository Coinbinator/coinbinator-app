import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/support/metas.dart';

class Rate {
  final Coin base;
  final Coin quote;

  double price = -1;

  Rate({this.base, this.quote});

  bool has(Coin coin) {
    if (base == coin || quote == coin) return true;
    return false;
  }

  toString() => "Rate(${base.symbol}=>${quote.symbol})";
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

    final fromAlias = coinAliases[from] ?? <Coin>{from};
    final toAlias = coinAliases[to] ?? <Coin>{to};

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

    final rateList = _recSearch(from, to);
    if (rateList != null && rateList.isNotEmpty) {
      return rateList.fold(1, (a, rate) => a(rate.base == from ? 1 / rate.price : rate.price)) * amount;
    }

    /// We didin't find the connection
    return -1;
  }

  List<Rate> _recSearch(Coin from, Coin to, {int level = 0}) {
    if (level > 3) return <Rate>[];

    final fromRates = rates.where((rate) => rate.has(from));

    var found = <Rate>[];

    for (final rate in fromRates) {
      final next = rate.quote == from ? rate.base : rate.quote;
      if (to == next) return [rate];

      final otherFound = _recSearch(next, to, level: level + 1);
      if (otherFound.isNotEmpty && (found.isEmpty || otherFound.length < found.length)) found = otherFound;
    }

    return found;
  }
}
