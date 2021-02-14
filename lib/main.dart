import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:le_crypto_alerts/models/app_model.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_page.dart';
import 'package:le_crypto_alerts/pages/settings/settings_page.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/background_service_support.dart';
import 'package:le_crypto_alerts/support/backgrund_service_manager.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:provider/provider.dart';

import 'consts.dart';

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

  runApp(app().rootWidget = LeApp());
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
  /// MessageTypes.TICKER;
  if (event["type"] == MessageTypes.TICKER) {
    var message = TickerMessage.fromJson(event["data"]);
    // app().watchListModel.updateTicker(message.ticker);
    return;
  }

  /// <MessageTypes.TICKERS>
  if (event["type"] == MessageTypes.TICKERS) {
    var message = TickersMessage.fromJson(event["data"]);
    // app().watchListModel.updateTickers(message.tickers);
    return;
  }

  print("Service message nao processada:");
  print(event);
}

class LeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppModel>(create: (context) => AppModel()),
        ],
        // child: HomePage(title: 'Le Crypto Alerts'),
        builder: (context, child) => MaterialApp(
              title: 'Le Crypto Alerts',
              theme: ThemeData(
                primarySwatch: LeColors.primary,
                accentColor: LeColors.accent,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              // initialRoute: ROUTE_ROOT,
              navigatorObservers: [
                app().routeObserver,
              ],
              routes: {
                // ROUTE_ROOT: (context) => HomePage(),
                ROUTE_WATCHING: (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider<WatchingPageModel>(create: (context) => WatchingPageModel()..initialize()),
                      ],
                      builder: (context, child) => WatchingPage(),
                    ),
                ROUTE_PORTFOLIO: (context) => PortfolioPage(),
                ROUTE_SETTINGS: (context) => SettingsPage(),
              },
              // home: HomePage(),
            ));
  }

  void navigateToWatching(BuildContext context) {
    //TODO: rever necessidade desses metodos de rotas ( com o pushNamed perderam o sentido )
    Navigator.pushNamed(context, ROUTE_WATCHING);
  }

  void navigateToPortfolio(BuildContext context) {
    //TODO: rever necessidade desses metodos de rotas ( com o pushNamed perderam o sentido )
    Navigator.pushNamed(context, ROUTE_PORTFOLIO);
  }
}
