import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/metas/coin.dart';

@Entity(tableName: 'alerts')
class AlertEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final Coin coin;

  final double referencePrice;

  final double limitPrice;

  int triggerState;

  DateTime triggerAt;

  AlertEntity({
    this.id,
    this.coin,
    this.referencePrice,
    this.limitPrice,
    this.triggerState = AlertEntityState.STATE_IDLE,
    this.triggerAt,
  });

  bool get isBullish {
    return referencePrice < limitPrice;
  }

  bool get isBearish {
    return referencePrice > limitPrice;
  }

  bool get isActive => triggerState == AlertEntityState.STATE_ACTIVE;

  bool testTrigger(double price) {
    if (price == null) return false;
    if (isBullish && price >= limitPrice) return true;
    if (isBearish && price <= limitPrice) return true;

    return false;
  }
}

abstract class AlertEntityState {
  static const int STATE_IDLE = 0;
  static const int STATE_ACTIVE = 1;
}
