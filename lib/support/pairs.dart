import 'package:le_crypto_alerts/support/codegen/le_coins_annotations.dart';
import 'package:le_crypto_alerts/support/utils.dart';

part 'pairs.le.pairs.dart';

@LePairsAnnotation()
// ignore: unused_element
const _ = null;

Pair _getPair(String value) {
  //TODO: mudar essa consulta para suportar a lista sem os alias
  return Pairs._pairs[value?.toUpperCase()];
}

List<Pair> _getAll() {
  //TODO: garantir uma lista unica para nao precisar desse filtro ( deve melhorar performance )
  return Pairs._pairs.values.toSet().toList();
}
