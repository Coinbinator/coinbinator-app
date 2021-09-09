import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/support/codegen/le_coins_annotations.dart';

part 'coins.le.coins.dart';

@LeCoinsAnnotation()
// ignore: unused_element
const _ = null;

//TODO: mover <unknownCoins> para dentro do <Coins>.
final unknownCoins = Map<String, Coin>();

Coin _getCoin(dynamic value) {
  if (value == null || value == "") return null;
  if (value is Coin) return _getCoin(value.symbol);

  assert(value is String, 'tipo inesperado para processar coin');

  final symbol = (value as String).toUpperCase();

  if (Coins._coins.containsKey(symbol)) {
    return Coins._coins[symbol];
  }

  //NOTE: é possivel que a versão compilada não coins. vamos salvar elas em uma lista a parte
  //TODO: adicionar referencia que essa coin não é conhecida ( na versão compilada )
  if (!unknownCoins.containsKey(symbol)) {
    // print("UNKNOWN COIN: $symbol");
    unknownCoins[symbol] = Coin.instance(symbol: symbol, name: symbol);
  }
  return unknownCoins[symbol];
}

Map<String, Coin> _getAll() {
  return Coins._coins;
}
