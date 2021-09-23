import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page_model.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/pages/splash/splash_model.dart';
import 'package:le_crypto_alerts/pages/splash/splash_page.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class LeApp extends StatefulWidget with RouteAware {
  @override
  State<StatefulWidget> createState() => LeAppState();
}

class LeAppState extends State<LeApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: _buildProviders(context),
        builder: (BuildContext context, child) {
          return Builder(

              /// WHY, WHY A BUILDER INSIDE A BUILDER??? You mey ask...
              /// Whell the DialogRoute needs to be inside of a
              /// Locatilizations, BUT it also needs a context from inside the same Localizations
              /// and if we use the context from "MultiProvider" it will not find the nested Localizations
              builder: (BuildContext context) => MaterialApp(
                    key: MAIN_APP_WIDGET,
                    title: 'Le Crypto Alerts',
                    navigatorKey: MAIN_NAVIGATOR_KEY,
                    theme: ThemeData(
                      primarySwatch: LeColors.primary,
                      accentColor: LeColors.accent,
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),
                    // initialRoute: ROUTE_ROOT,
                    onGenerateInitialRoutes: _onGenerateInitialRoutes,
                    onGenerateRoute: (settings) =>
                        _onGenerateRoute(context, settings),

                    // oownRoute: (settings) {
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
                    // home: SplashPage(),
                  ));
        });
  }

  List<SingleChildWidget> _buildProviders(BuildContext context) {
    return [
      ///APP MODEL PROVIDER
      ChangeNotifierProvider<LeAppModel>(
          create: (context) => LeAppModel()..init()),

      //MAIN PROGRESS INDICATOR
      ChangeNotifierProvider<LeAppMainProgressIndicatorNotifier>(
          create: (context) => LeAppMainProgressIndicatorNotifier()),

      ///SPLASH MODEL PROVIDER
      ChangeNotifierProvider<SplashModel>(
        create: (context) => SplashModel(),
      ),

      /// ALERTS MODEL PROVIDER
      ChangeNotifierProvider<AlertsListPageModel>(
          create: (context) => AlertsListPageModel()..init()),
    ];
  }

  List<Route<dynamic>> _onGenerateInitialRoutes(String initialRoute) {
    return [
      MaterialPageRoute(builder: (_) => SplashPage()),
      // getWatchingPageRoute(),
    ];
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    // /// WATCHING :: LIST
    // if (ROUTE_WATCHING == settings.name) {
    //   return getWatchingPageRoute();
    // }

    // /// ALERTS :: LIST
    // if (ROUTE_ALERTS == settings.name) {
    //   return getAlertListPageRoute();
    // }

    // /// ALERTS :: CREATE
    // if (ROUTE_ALERTS_CREATE == settings.name) {
    //   return alertCreatePageRoute(context);
    // }

    // /// PORTIFOLIO :: LIST
    // if (ROUTE_PORTFOLIO == settings.name) {
    //   return MaterialPageRoute(
    //       settings: RouteSettings(name: ROUTE_PORTFOLIO),
    //       builder: (_) =>
    //           Stack(fit: StackFit.expand, clipBehavior: Clip.none, children: [
    //             PortfolioPage(),
    //             Opacity(
    //                 opacity: .0,
    //                 child: IgnorePointer(
    //                     child: Image(
    //                         image:
    //                             AssetImage('assets/refs/screenshot_1.png')))),
    //           ]));
    // }

    /// UNKNOW
    return MaterialPageRoute(
        builder: (_) => Container(
            child: Text("Unknow Route, name: ${settings?.name}, $settings")));
  }
}
