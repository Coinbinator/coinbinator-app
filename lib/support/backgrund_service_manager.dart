import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:le_crypto_alerts/repositories/binance_repository.dart';
import 'package:le_crypto_alerts/support/background_service_support.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class BackgroundServiceManager {
  final FlutterBackgroundService _service;

  final BinanceRepository _binance = new BinanceRepository();

  final ExchangesMeta _meta = new ExchangesMeta();

  int _working = 0;

  BackgroundServiceManager(this._service) : super() {
    _service.setForegroundMode(true);
    _service.setAutoStartOnBootMode(true);
    _service.onDataReceived.listen((event) => _serviceOnDataReceived(event));
  }

  void start() async {
    await _loadExchangeInfo();

    Timer.periodic(Duration(seconds: 5), (timer) async {
      //NOTE: is service still running
      if (!(await _service.isServiceRunning())) {
        timer.cancel();
        return;
      }

      //NOTE: we are working before the last work completed?
      _working += 1;
      if (_working > 1) return;

      await _checkCryptos();

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
      _working = 0;
    });
  }

  Future<void> _loadExchangeInfo() async {
    //
    // NOTE: BINANCE
    print("Load exchange info ( binance )");

    print("  load pairs");
    var pairs = await _binance.getExchangePairs();
    _meta.pairs.addAll(pairs);

    print("  load tickers");
    var tickers = (await _binance.getTickerPrice()).map((ticker) => new Ticker(
          pair: _meta.pairs.firstWhere((element) => element.exchangePair == ticker.symbol),
          price: ticker.price,
        ));
    _meta.tickers.addAll(tickers);

    print("  done");
  }

  Future<void> _checkCryptos() async {
    try {
      print("Check cryptos ( binance )");
      (await _binance.getTickerPrice()).forEach((binanceTicker) {
        var ticker = _meta.tickers.firstWhere((element) => element.pair.exchangePair == binanceTicker.symbol);
        ticker.price = binanceTicker.price;
        ticker.date = DateTime.now();

        if (ticker.pair.pair == "BTC/USDC") {
          _service.setNotificationInfo(
            title: "${ticker.pair}",
            content: "${ticker.price} @ ${DateTime.now()}",
          );

          print("send data");
          _service.sendData({"type": MessageTypes.TICKER, "data": TickerMessage(ticker)});

          // _service.sendData(
          //   {"current_date": DateTime.now().toIso8601String()},
          // );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _serviceOnDataReceived(Map<String, dynamic> event) async {
    print("---");
    print(event);

    if (event["action"] == "setAsForeground") {
      _service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      _service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      _service.stopBackgroundService();
    }
  }
}
