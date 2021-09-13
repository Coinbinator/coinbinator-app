import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/metas/coin.dart';

@Entity(tableName: 'alerts')
class AlertEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final Coin coin;

  final double referencePrice;

  final double limitPrice;

  AlertEntity({
    this.id,
    this.coin,
    this.referencePrice,
    this.limitPrice,
  });
}
