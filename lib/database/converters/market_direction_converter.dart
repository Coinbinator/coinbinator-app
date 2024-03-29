import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/converters/abstract_enum_converter.dart';

class MarketDirectionConverter extends TypeConverter<MarketDirection, int> with EnumConverter<MarketDirection> {
  @override
  List<MarketDirection> get values => MarketDirection.values;
}

// class MarketDirectionConverter extends TypeConverter<MarketDirection, int> {
//   @override
//   MarketDirection decode(int value) {
//     if (value == null || value < 0 || value >= MarketDirection.values.length) return null;
//     return MarketDirection.values.elementAt(value);
//   }

//   @override
//   int encode(MarketDirection value) {
//     return value?.index ?? null;
//   }
// }
