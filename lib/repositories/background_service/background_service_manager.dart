import 'dart:async';

import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/bridges/background_service_bridge.dart';
import 'package:le_crypto_alerts/repositories/background_service/messages/messages.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class BackgroundServiceManager {
  final BackgroundServiceBridge _bridge;

  final BinanceRepository _binance = instance<BinanceRepository>();

  int _working = 0;

  BackgroundServiceManager(this._bridge) : super();

  start() async {
    Timer.periodic(Duration(seconds: 5), _tick);
  }

  _tick(Timer timer) async {
    if (_bridge == null) {
      print("no bridge");
      return;
    }

    if (!(await _bridge.isServiceRunning())) {
      timer.cancel();
      return;
    }

    _bridge.sendData({'type': 'ping'});

    final accounts = await app().getAccounts();
    final watchingModel = WatchingPageModel();
    await watchingModel.initialize();

    // print(watchingModel.watchingTickers);

    final exchanges = Set<Exchange>.from([
      ...accounts.map((e) => e.getExchange()),
      ...watchingModel.watchingTickers.map((e) => e.exchange),
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
        // print( exchangeTicker ); print( exchangeTicker.lePair);
        final ticker = app().tickers.getTicker(Exchanges.Binance, exchangeTicker.lePair, register: true);

        if (ticker == null) continue;

        ticker.price = double.tryParse(exchangeTicker.price);
        ticker.date = DateTime.now();

        tickers.add(ticker);
      }

      _bridge.sendData({"type": MessageTypes.TICKERS, "data": TickersMessage(tickers)});
    } catch (e) {
      print("err:");
      print(e);
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
