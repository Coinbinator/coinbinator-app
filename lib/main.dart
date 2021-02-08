import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:le_crypto_alerts/database/Persistence.dart';
import 'package:le_crypto_alerts/models/app_model.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_page.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_support.dart';
import 'package:le_crypto_alerts/support/background_service_support.dart';
import 'package:le_crypto_alerts/support/backgrund_service_manager.dart';
import 'package:provider/provider.dart';


// void printHello() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//
//   print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
// }
LeApp leApp;

Future<void> main() async {
  await app().loadConfig();
  Intl.defaultLocale = "en_US";

  backgroundServiceInit();

  runApp(leApp = LeApp(backgroundServiceOnStart: backgroundServiceOnStart));
}

void backgroundServiceInit() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterBackgroundService.initialize(backgroundServiceOnStart);
  FlutterBackgroundService().onDataReceived.listen(backgroundServiceSentMessage);
}

void backgroundServiceOnStart() {
  WidgetsFlutterBinding.ensureInitialized();

  final service = FlutterBackgroundService();
  final backgroundServiceManager = BackgroundServiceManager(service);
  backgroundServiceManager.start();
}

void backgroundServiceSentMessage(Map<String, dynamic> event) {
  if (event["type"] == MessageTypes.TICKER) {
    var message = TickerMessage.fromJson(event["data"]);
    leApp.watchListModel.updateTicker(message.ticker);
    return;
  }

  if (event["type"] == MessageTypes.TICKERS) {
    var message = TickersMessage.fromJson(event["data"]);
    leApp.watchListModel.updateTickers(message.tickers);
    return;
  }

  print("Service message nao processada:");
  print(event);
}

class LeApp extends StatelessWidget {
  final backgroundServiceOnStart;

  final appModel = AppModel();

  final watchListModel = WatchingPageModel();

  final persistence = Persistence();

  LeApp({this.backgroundServiceOnStart}) : super() {
    // () async {
    //   await persistence.open();
    //   print("persistence initialized");
    // }();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppModel>(create: (context) => AppModel()),
          ChangeNotifierProvider<WatchingPageModel>(create: (context) {
            watchListModel.initialize();

            return watchListModel;
          }),
        ],
        // child: HomePage(title: 'Le Crypto Alerts'),
        builder: (context, child) => MaterialApp(
              title: 'Le Crypto Alerts',
              theme: ThemeData(
                primarySwatch: Colors.blueGrey,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                accentColor: Colors.amberAccent,
              ),
              home: WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: WatchingPage(title: "MAIN")),
            ));
  }

  void navigateToWatching(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WatchingPage(title: "page 1"),
        ));
  }

  void navigateToPortfolio(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PortfolioPage(),
        ));
  }
}
