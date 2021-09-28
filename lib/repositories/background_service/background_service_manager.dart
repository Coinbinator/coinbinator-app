import 'dart:async';

import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/alert_trugger_info.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/messages/messages.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/speech/SpeechRepository.dart';
import 'package:le_crypto_alerts/repositories/vibrate/vibrate_repository.dart';
import 'package:le_crypto_alerts/support/metas.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

///
/// The backgund process program
class BackgroundServiceManager {
  final BackgroundServiceBridge _bridge;

  final BinanceRepository _binance = instance<BinanceRepository>();

  bool _isTickRunning = false;

  DateTime alertAlarmAt;

  BackgroundServiceManager(this._bridge) : super();

  Map<Pair, double> binanceCurrentPrices = {};

  bool _isCheckingAlerts = false;

  start() async {
    Timer.periodic(Duration(seconds: 5), _tick);
    Timer.periodic(Duration(seconds: 5), _checkAlerts);
  }

  _tick(Timer timer) async {
    ///NOTE: managerm se bridge
    if (_bridge == null) {
      print("(_tick): no bridge");
      return;
    }

    ///NOTE: servico parou
    if (!(await _bridge.isServiceRunning())) {
      print("(_tick): service is not running");
      timer.cancel();
      return;
    }

    if (_isTickRunning) {
      print("(_tick): tick running concurrence");
      return;
    }
    _isTickRunning = true;

    ///
    _bridge.sendData({'type': 'ping'});

    final accounts = await app().getAccounts();
    final tickerWatches = await app().appDao.findAllTickerWatches();

    // print(watchingModel.watchingTickers);

    final exchanges = Set<Exchange>.from([
      ...accounts.map((e) => e.getExchange()),
      ...tickerWatches.map((e) => Exchange(e.exchange)),
    ]);

    for (final exchange in exchanges) {
      switch (exchange) {
        case Exchanges.Binance:
          _checkCryptosFromBinance();
          break;
        // case Exchanges.MercadoBitcoin:
        //   _checkCryptosFromBinance();
        //   break;
      }
    }

    // await _loadExchangeInfo();

    //NOTE: we are working before the last work completed?
    // _working += 1;
    // if (_working > 1) return;
    //
    // await _checkCryptos();

    // await Future.delayed(Duration(seconds: 5));

    // _service.setNotificationInfo(
    //   title: "My App Service",
    //   content: "- Updated at ${DateTime.now()}",
    // );
    //
    // _service.sendData(
    //   {"current_date": DateTime.now().toIso8601String()},
    // );

    // print("X $_working");
    // _working = 0;
    _isTickRunning = false;
  }

  Future<void> _loadExchangeInfo() async {
    //
    // NOTE: BINANCE
    print("Load exchange info ( binance )");

    print("  load pairs");
    // var pairs = await _binance.getExchangePairs();
    // _meta.pairs.addAll(pairs);

    // print(pairs);

    // print("  load tickers");
    // var tickers = (await _binance.getTickerPrice())
    //     //
    //     .map((ticker) => new Ticker(
    //           pair: _meta.pairs.firstWhere((pair) => _binance.convertPairToSymbol(pair) == ticker.symbol),
    //           price: double.tryParse(ticker.price),
    //           date: DateTime.now(),
    //         ));
    // _meta.tickers.addAll(tickers);

    print("  done");
  }

  // Future<void> _checkCryptos() async {
  //   await Future.wait([
  //     _checkCryptosFromBinance(),
  //   ]);
  // }

  Future<void> _checkCryptosFromBinance() async {
    try {
      print("Check cryptos ( binance )");
      final exchangeTickers = await _binance.getTickerPrice();

      final tickers = List<Ticker>.empty(growable: true);

      for (final exchangeTicker in exchangeTickers) {
        //NOTE:
        // checking if the price changed, before notify main app
        final tickerLastPrice = binanceCurrentPrices[exchangeTicker.lePair];
        if (tickerLastPrice != null && tickerLastPrice == double.tryParse(exchangeTicker.price)) continue;

        final staticTicker = app().tickers.getTicker(
              Exchanges.Binance,
              exchangeTicker.lePair,
              createOnMissing: true,
            );

        if (staticTicker == null) continue;

        staticTicker.price = double.tryParse(exchangeTicker.price);
        staticTicker.updatedAt = DateTime.now();

        tickers.add(staticTicker);
        binanceCurrentPrices[exchangeTicker.lePair] = staticTicker.price;
      }

      if (tickers.isNotEmpty) {
        _bridge.sendData({
          "type": MessageTypes.TICKERS,
          "data": TickersMessage(tickers),
        });
      }
    } catch (e) {
      print("err:");
      print(e);
    }
  }

  Future<void> _checkAlerts(Timer timer) async {
    if (_isCheckingAlerts) return;
    try {
      _isCheckingAlerts = true;
      final activeAlerts = <AlertTriggerInfo>[];

      for (AlertEntity alert in await app().appDao.findAllAlerts()) {
        final ticker = app().tickers.getTicker(
              Exchanges.Binance,
              Pairs.getPair2(alert.coin.symbol, CoinsEx.USD_ALIASES),
            );

        if (ticker == null) continue;

        // print("checking $alert");

        if (alert.testTrigger(ticker.price)) {
          activeAlerts.add(AlertTriggerInfo(
            alert: alert,
            price: ticker.price,
          ));
        }
      }

      if (activeAlerts.isNotEmpty) {
        if (alertAlarmAt == null || DateTime.now().difference(alertAlarmAt).inSeconds >= 5) {
          alertAlarmAt = DateTime.now();

      // app().appDao.updateAlert(alert)


          _bridge.sendData({
            "type": MessageTypes.ACTIVE_ALERTS,
            "data": ActiveAlertsMessage(activeAlerts.map((e) => e.alert.id).toList()),
          });

          // Bringtoforeground.bringAppToForeground();
          //runApp(LeApp());

          // await Future.wait([
          //   instance<VibrateRepository>().vibrateWithPauses(),
          //   instance<SpeechRepository>().speak("You have ${activeAlerts.length} alert triggered."),
          // ]);

          //instance<SpeechRepository>().speak(alert.describe(price));
          //instance<SpeechRepository>().speak("Hello");
          // FlutterRingtonePlayer.play(
          //   android: AndroidSounds.notification,
          //   ios: IosSounds.glass,
          //   looping: false, // Android only - API >= 28
          //   volume: 0.1, // Android only - API >= 28
          //   asAlarm: true, // Android only - all APIs
          // );
          // asdadadadasda();
          // instance<AlarmingRepository>().oneShot(
          //     Duration(seconds: 2), ALARM_ID_ALERT_ACTIVE, asdadadadasda,
          //     wakeup: true, exact: true, allowWhileIdle: true, alarmClock: true);
        }
      }
    } catch (e) {
      throw e;
    } finally {
      _isCheckingAlerts = false;
    }
  }

  void _serviceOnDataReceived(Map<String, dynamic> event) async {
    print("---");
    print(event);

    // if (event["action"] == "setAsForeground") {
    //   _bridge.setForegroundMode(true);
    //   return;
    // }
    //
    // if (event["action"] == "setAsBackground") {
    //   _bridge.setForegroundMode(false);
    // }
    //
    // if (event["action"] == "stopService") {
    //   _bridge.stopBackgroundService();
    // }
  }

  void onDataReceived(Map<String, dynamic> event) {
    print('manager received: ');
    print(event);
    print('---');
  }
}

// asdadadadasda() {
// print(
//     " 2ALERT ALARM ALERT ALARM ALERT ALARM ALERT ALARM ALERT ALARM ALERT ALARM ");
// print(
//     "2 ALERT ALARM ALERT ALARM ALERT ALARM ALERT ALARM ALERT ALARM ALERT ALARM ");
// }
