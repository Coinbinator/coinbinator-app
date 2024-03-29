import 'dart:math';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/metas.dart';
import 'package:path/path.dart';

class AlertsCreatePageModel extends ChangeNotifier {
  AlertEntity alert;

  List<Coin> commonCoins = <Coin>[
    Coins.$BTC,
  ];

  List<double> priceLimitModifiers = <double>[
    0 - 1.00,
    0 - 0.50,
    0 - 0.25,
    0 - 0.10,
    0 - 0.01,
    0 + 0.00,
    0 + 0.01,
    0 + 0.10,
    0 + 0.25,
    0 + 0.50,
    0 + 1.00,
  ];

  Coin selectedCoin;

  double selectedCoinCurrentPrice = 0;

  MarketDirection limitDirection = MarketDirection.bullish;

  double limitPrice = 0;

  double get _currentPriceNotZero => selectedCoinCurrentPrice <= 0 ? 100 : selectedCoinCurrentPrice;

  double get limitPriceVariation {
    if (limitPrice == 0) return 0;
    final variation = limitPrice / _currentPriceNotZero;
    if (variation > limitPriceVariationMax) return limitPriceVariationMax;
    if (variation < limitPriceVariationMin) return limitPriceVariationMin;
    return variation;
  }

  double get limitPriceVariationMin => limitDirection == MarketDirection.bullish ? 1 : 0;
  double get limitPriceVariationMax => limitDirection == MarketDirection.bullish ? 3 : 1;

  set limitPriceVariation(double value) {
    limitPrice = _currentPriceNotZero * value;
    notifyListeners();
  }

  AlertsCreatePageModel(this.alert);

  init() async {
    if (alert != null) {
      await setSelectedCoin(alert.coin);
      limitDirection = alert.limitDirection;
      limitPrice = alert.limitPrice;

      notifyListeners();
      return;
    }

    //
    await setSelectedCoin(commonCoins.first);
    notifyListeners();
  }

  @override
  dispose() {
    alert = null;
    commonCoins = null;
    limitDirection = null;
    limitPrice = null;
    priceLimitModifiers = null;
    selectedCoin = null;
    selectedCoinCurrentPrice = null;
    super.dispose();
  }

  Set<Coin> get availableCoins {
    return Pairs.getAll()
        .where((element) {
          return !element.base.isUSD && !element.base.isUnknown && element.quote.isUSD;
        })
        .map((e) => e.base)
        .toSet()
          ..add(selectedCoin);
  }

  setSelectedCoin(Coin value) async {
    selectedCoin = value;

    final ticker = app().tickers.getTicker(Exchanges.Binance, Pairs.getPair2(value.symbol, CoinsEx.USD_ALIASES));

    selectedCoinCurrentPrice = ticker?.closePrice ?? -1;
    limitPrice = ticker?.closePrice ?? _currentPriceNotZero;

    notifyListeners();
  }

  setLimitDirection(MarketDirection value) {
    limitDirection = value;
    limitPrice = _currentPriceNotZero;
    notifyListeners();
  }

  applyPriceLimitModifier(double value) {
    if (value == 0) {
      limitPrice = selectedCoinCurrentPrice;
      notifyListeners();
      return;
    }

    // final basePrice = limitPrice != 0 ? limitPrice : currentPrice != 0 ? currentPrice : 100;
    //final basePrice = currentPrice != 0 ? currentPrice : 100;

    limitPrice = max(0, limitPrice + (_currentPriceNotZero * value));
    notifyListeners();
  }

  commitAlarm(BuildContext context) async {
    if (alert == null) {
      await app().persistAlertEntity(AlertEntity(
        coin: selectedCoin,
        // referencePrice: selectedCoinCurrentPrice,
        limitDirection: limitDirection,
        limitPrice: limitPrice,
      ));
      Navigator.of(context).pop();
      return;
    }
    await app().persistAlertEntity(alert
      ..coin = selectedCoin
      //..referencePrice = selectedCoinCurrentPrice
      ..limitDirection = limitDirection
      ..limitPrice = limitPrice);
    Navigator.of(context).pop();
  }

  cancelAlarm(BuildContext context) async {
    Navigator.of(context).pop();
  }

  removeAlarm(BuildContext context) async {
    await app().removeAlertEntity(alert);
    Navigator.of(context).pop();
  }

  T when<T>({
    T Function() creating,
    T Function() editing,
  }) {
    if (alert != null) return editing?.call() ?? [];

    return creating?.call() ?? [];
  }
}
