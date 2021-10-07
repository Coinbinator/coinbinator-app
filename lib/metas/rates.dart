import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/rate.dart';
import 'package:le_crypto_alerts/support/metas.dart';

/// Stores the conversion rate for the known pairs
/// Provides utilities for [Coin] rates manipulation and conversion
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

  /// Returnn the amount (in from [Coin]) converted into the amount in to [Coin]
  /// using the currently known prices
  ///
  /// TODO: validate and test other algos ( for performance improvements )
  ///
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

    final rateList = _getRateFromTo__recSearch(from, to);
    if (rateList != null && rateList.isNotEmpty) {
      if (Pair.instance(base: from, quote: to).has(Coins.$AAVE)) {
        to.toString();
      }

      return rateList.reversed.fold(1, (a, rate) => a * rate.price) * amount;
    }

    /// We didin't find the connection
    return -1;
  }

  /// Execute a recursive search for amount conversion
  /// Used when we don't have a direct price for the symbol
  ///
  /// And we use one or many intermediary "hops".
  ///
  /// TODO: theres is room for improvement, like wont lookup the rates already in the stack
  ///
  // ignore: non_constant_identifier_names
  List<Rate> _getRateFromTo__recSearch(Coin from, Coin to, {int level = 0}) {
    if (level > 3) return null;

    final fromRates = rates.where((rate) => rate.has(from));
    List<Rate> found;

    for (final rate in fromRates) {
      final next = rate.quote == from ? rate.base : rate.quote;
      if (to == next) return [rate];

      final otherFound = _getRateFromTo__recSearch(next, to, level: level + 1);
      if (otherFound != null && (found == null || otherFound.length < found.length - 1)) {
        found = [rate, ...otherFound];
      }
    }

    return found;
  }
}
