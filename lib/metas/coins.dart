import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/support/codegen/le_coins_annotations.dart';
import 'package:le_crypto_alerts/support/utils.dart';

part 'coins.le.coins.dart';

@LeCoinsAnnotation()
// ignore: unused_element
const _ = null;

//TODO: mover <unknownCoins> para dentro do <Coins>.
final _unknownCoins = Map<String, Coin>();

Coin _getCoin(dynamic value) {
  if (value == null || (value is String && value.isEmpty)) return null;

  if (value is Coin) return _getCoin(value.symbol);

  if (value is Iterable<dynamic>) {
    for (final c in value) {
      //NOTE:
      // a minor performance boost
      // converting <Coin> to string here, before passing to _getCoin again _( as its the most common usecase )_
      // avoiding "one" level of recursion
      final coin = _getCoin(c is Coin ? c.symbol : c);

      if (coin != null) return coin;
    }
    return null;
  }

  assert(value is String, 'tipo inesperado para processar coin');

  final symbol = (value as String).toUpperCase();

  if (Coins._coins.containsKey(symbol)) {
    return Coins._coins[symbol];
  }

  //NOTE: é esperado que a versão compilada não possua todas coins existentes. vamos salvar elas em uma lista a parte
  //TODO: adicionar referencia que essa coin não é conhecida ( na versão compilada )
  if (!_unknownCoins.containsKey(symbol)) {
    // print("UNKNOWN COIN: $symbol");
    _unknownCoins[symbol] = Coin.instance(symbol: symbol, name: symbol);
  }
  return _unknownCoins[symbol];
}

Map<String, Coin> _getAll() {
  return Coins._coins;
}
