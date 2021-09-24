import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/metas/coin.dart';

@Entity(tableName: 'alerts')
class AlertEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  Coin coin;

  MarketDirection limitDirection;

  double limitPrice;

  int triggerState;

  DateTime triggerAt;

  AlertEntity({
    this.id,
    this.coin,
    this.limitDirection,
    this.limitPrice,
    this.triggerState = AlertEntityState.STATE_IDLE,
    this.triggerAt,
  });

  bool get isBullish => limitDirection == MarketDirection.bullish;

  bool get isBearish => limitDirection == MarketDirection.bearish;

  bool get isActive => triggerState == AlertEntityState.STATE_ACTIVE;

  bool testTrigger(double price) {
    if (price == null) return false;
    if (isBullish && price >= limitPrice) return true;
    if (isBearish && price <= limitPrice) return true;

    return false;
  }

  String describe(double price) {
    final normPrice = price < 100 ? price : price.round();
    final normLimitPrice = limitPrice < 100 ? limitPrice : limitPrice.round();
    final percentage =  ((limitPrice/price - 1) * 100).round();

    return "${coin.name} is ${isBearish ? 'bellow' : 'above'} \$$normLimitPrice, currently at \$$normPrice. ${percentage > 2 ? 'with a $percentage variation' :''}";
    // return "${coin.name} está ${isBearish ? 'abaixo' : 'acima'} de $normLimitPrice dollars, no valor atual de $normPrice dollars.";
  }
}

abstract class AlertEntityState {
  static const int STATE_IDLE = 0;
  static const int STATE_ACTIVE = 1;
}
