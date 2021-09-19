import 'dart:math';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

class AlertsCreatePageModel extends ChangeNotifier {
  List<Coin> commonCoins = <Coin>[
    Coins.$BTC,
    Coins.$ETH,
    Coins.$XRP,
    Coins.$ADA,
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

  Coin userCoin;

  Coin selectedCoin;

  double currentPrice = 0;

  double get _currentPriceNotZero => currentPrice <= 0 ? 100 : currentPrice;

  double limitPrice = 0;

  double get limitPriceVariation {
    return limitPrice == 0 ? -1 : (limitPrice / _currentPriceNotZero - 1);
  }

  set limitPriceVariation(double value) {
    limitPrice = _currentPriceNotZero + _currentPriceNotZero * value;
    notifyListeners();
  }

  init() async {
    setSelectedCoin(Coins.$BTC);
  }

  setSelectedCoin(Coin value) async {
    selectedCoin = value;

    final ticker = app()
        .tickers
        .getTicker(Exchanges.Binance, Pairs.getPair(value.symbol + "USDT"));

    currentPrice = ticker?.price ?? -1;
    limitPrice = ticker?.price ?? _currentPriceNotZero;

    notifyListeners();
  }

  applyPriceLimitModifier(double value) {
    if (value == 0) {
      limitPrice = currentPrice;
      notifyListeners();
      return;
    }

    // final basePrice = limitPrice != 0 ? limitPrice : currentPrice != 0 ? currentPrice : 100;
    //final basePrice = currentPrice != 0 ? currentPrice : 100;

    limitPrice = max(0, limitPrice + (_currentPriceNotZero * value));
    notifyListeners();
  }

  commitAlarm(BuildContext context) async {
    await app().registerAlert(AlertEntity(
      coin: selectedCoin,
      referencePrice: currentPrice,
      limitPrice: limitPrice,
    ));

    Navigator.of(context).pop();
  }

  cancelAlarm(BuildContext context) {
    Navigator.of(context).pop();
  }
}