import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_support.dart';

enum CryptoAlertType { ABSOLUTE, PERCENTAGE }

class AlarmDefaultHandler {
  final List<CryptoPairAlert> alerts = [
    CryptoPairAlert(
      pair: Pairs.getPair('BTC/USDT'),
      type: CryptoAlertType.ABSOLUTE,
      referenceValue: 50000.00,
      alertValue: 51200.00,
    ),
    CryptoPairAlert(
      pair: Pairs.getPair('ETH/USDT'),
      type: CryptoAlertType.ABSOLUTE,
      referenceValue: 1912.00,
      alertValue: 1915.00,
    ),
  ];

  Future<FlutterTts> getTts() async {
    final tts = FlutterTts();

    await tts.setVolume(.6);
    await tts.awaitSpeakCompletion(true);
    await tts.awaitSpeakCompletion(true);

    // https://dl.google.com/dl/android/tts/v2/voices-list-r1.proto
    for (final voice in await tts.getVoices) print("-- " + voice['name']);

    for (final voice in await tts.getVoices) {
      final say = () {
        final name = voice['name'] as String;
        final locale = voice['locale'] as String;

        if (name == 'pt-br-x-afs-network') return false;
        if (name == 'pt-br-x-afs#female_1-local') return false;
        if (name == 'pt-pt-x-pmj-local') return false;
        if (name == 'pt-pt-x-sfs-network') return false;
        if (name == 'pt-pt-x-sfs-local') return false;

        if (locale.startsWith("pt-PT")) return true;

        return false;
      }();

      if (!say) continue;

      print(voice);
      await tts.setVoice({"name": voice['name'], "locale": voice['locale']});
      break;

      // print(i);
      // print(voice);
      // final result = await flutterTts.speak("Sir... BTC is bellow twelve thousand dollars");
    }

    return tts;
  }

  FutureOr<void> handleAlarm(int alarmId) async {
    final tickers = await instance<BinanceRepository>().getTickerPrice();

    final alertsInfos = alerts.asMap().map((key, value) => MapEntry(
          value,
          tickers.firstWhere((element) => element.lePair == value.pair, orElse: () => null),
        ));

    final firingAlerts = {...alertsInfos}..removeWhere((alert, ticker) => !alert.shouldFire(ticker));

    if (firingAlerts.isEmpty) return;

    String message = "";

    // message += "There are ${firingAlerts.length} firing alerts,\n";

    message += "chupa essa manga manolo.";
    message += "Existem ${firingAlerts.length} alertas ativos... ";

    int i = 1;
    firingAlerts.forEach((alert, ticker) {
      message += "alerta $i, " + alert.describe(ticker) + ".. ";
      i++;
    });

    // message += "CHUPA Essa manga";

    final tts = await getTts();
    await tts.speak(message);

    print('---');
    print(firingAlerts);
    // final tts = await getTts();
    // final result = await tts.speak("Sir... BTC is bellow twelve thousand dollars");
    // print(result);
    print('---');
  }
}

class CryptoPairAlert {
  final Pair pair;
  final CryptoAlertType type;
  final double referenceValue;
  final double alertValue;

  CryptoPairAlert({
    this.pair,
    this.type,
    this.referenceValue,
    this.alertValue,
  });

  int get alertDirection => referenceValue < alertValue ? 1 : -1;

  bool shouldFire(BinanceTickerPrice ticker) {
    final tickerPrice = double.tryParse(ticker.price);

    if (type == CryptoAlertType.ABSOLUTE) {
      print("Alert if: $tickerPrice ${alertDirection < 0 ? 'bellow' : 'above'} $alertValue");
      if (alertDirection > 0) return tickerPrice >= alertValue;
      if (alertDirection < 0) return tickerPrice <= alertValue;
    }

    return false;
  }

  String describe(BinanceTickerPrice ticker) {
    final tickerPrice = double.tryParse(ticker.price);

    if (type == CryptoAlertType.ABSOLUTE) {
      // return "${pair.quoteCoin.name} is ${alertDirection < 0 ? 'bellow' : 'above'} $alertValue ${pair.baseCoin.name}, currently at $tickerPrice ${pair.baseCoin.name}.";
      return "${pair.quoteCoin.name} está ${alertDirection < 0 ? 'abaixo' : 'acima'} de ${alertValue > 100 ? alertValue.round() : alertValue} ${pair.baseCoin.name}, no valor atual de ${tickerPrice > 100 ? tickerPrice.round() : tickerPrice} ${pair.baseCoin.name}.";
    }

    return "undefined description";
  }
}

// ignore: non_constant_identifier_names
void alarm__defaultCallback(int alarmId) async {
  print(AlarmDefaultHandler().alerts);
  await AlarmDefaultHandler().handleAlarm(alarmId);
}
