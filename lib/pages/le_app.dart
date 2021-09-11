import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/models/app_model.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_page.dart';
import 'package:le_crypto_alerts/pages/settings/settings_page.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:provider/provider.dart';

class LeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppModel>(create: (context) => AppModel()..init()),
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
                ROUTE_ALERTS: (context) => AlertsPage(),
                ROUTE_PORTFOLIO: (context) => PortfolioPage(),
                // ROUTE_PORTFOLIO_DETAILS: (context) => PortfolioDetailsPage(),
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
