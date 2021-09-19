import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/localization/DefaultLocalization.dart';
import 'package:le_crypto_alerts/models/app_model.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_page.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:provider/provider.dart';

class LeApp extends StatelessWidget with RouteAware {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppModel>(
              create: (context) => AppModel()..init()),
        ],
        builder: (BuildContext context, child) {
          return Localizations(
            locale: const Locale('en', 'US'),
            delegates: [
              DefaultWidgetsLocalizations.delegate,
              DefaultMaterialLocalizations.delegate,
              AppLocalizationDelegate(),
            ],
            child: Builder(

                /// WHY, WHY A BUILDER INSIDE A BUILDER??? You mey ask...
                /// Whell the DialogRoute needs to be inside of a
                /// Locatilizations, BUT it also needs a context from inside the same Localizations
                /// and if we use the context from "MultiProvider" it will not find the nested Localizations
                builder: (BuildContext context) => MaterialApp(
                      title: 'Le Crypto Alerts',
                      theme: ThemeData(
                        primarySwatch: LeColors.primary,
                        accentColor: LeColors.accent,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      // initialRoute: ROUTE_ROOT,
                      onGenerateInitialRoutes: _onGenerateInitialRoutes,
                      onGenerateRoute: (settings) =>
                          _onGenerateRoute(context, settings),
                      // onUnknownRoute: (settings) {
                      //   settings.toString();
                      //   return MaterialPageRoute(builder: (_) => Container());
                      // },
                      // navigatorObservers: [
                      //   app().routeObserver,
                      // ],
                      // routes: {
                      //   // ROUTE_ROOT: (context) => HomePage(),
                      //   ROUTE_ALERTS: (context) => AlertsPage(),
                      //   // ROUTE_PORTFOLIO_DETAILS: (context) => PortfolioDetailsPage(),
                      //   ROUTE_SETTINGS: (context) => SettingsPage(),
                      // },
                      // home: HomePage(),
                    )),
          );
        });
  }

  List<Route<dynamic>> _onGenerateInitialRoutes(String initialRoute) {
    return [
      getWatchingPageRoute(),
    ];
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    settings.toString();

    /// WATCHING :: LIST
    if (ROUTE_WATCHING == settings.name) {
      return getWatchingPageRoute();
    }

    /// ALERTS :: LIST
    if (ROUTE_ALERTS == settings.name) {
      return getAlertListPageRoute();
    }

    /// ALERTS :: CREATE
    if (ROUTE_ALERTS_CREATE == settings.name) {
      return alertCreatePageRoute(context);
    }

    /// PORTIFOLIO :: LIST
    if (ROUTE_PORTFOLIO == settings.name) {
      return MaterialPageRoute(
          settings: RouteSettings(name: ROUTE_PORTFOLIO),
          builder: (_) =>
              Stack(fit: StackFit.expand, clipBehavior: Clip.none, children: [
                PortfolioPage(),
                Opacity(
                    opacity: .0,
                    child: IgnorePointer(
                        child: Image(
                            image:
                                AssetImage('assets/refs/screenshot_1.png')))),
              ]));
    }

    /// UNKNOW
    return MaterialPageRoute(builder: (_) => Container());
  }
}
