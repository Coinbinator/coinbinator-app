import 'dart:async';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/localization/DefaultLocalization.dart';
import 'package:le_crypto_alerts/pages/le_app_model.dart';
import 'package:le_crypto_alerts/pages/splash/splash_model.dart';
import 'package:le_crypto_alerts/pages/splash/splash_page.dart';
import 'package:le_crypto_alerts/repositories/alarming/alarming_repository.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/background_service/background_service_repository.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:provider/provider.dart';

class LeApp extends StatefulWidget with RouteAware {
  @override
  State<StatefulWidget> createState() => LeAppState();
}

class LeAppState extends State<LeApp> {
  @override
  initState() {
    super.initState();

    /// shorhand para atializacao das mensagens do Slash
    _say(String message) => MAIN_APP_WIDGET?.currentContext
        ?.read<SplashModel>()
        ?.setInitializetionMessage(message);

    Future.microtask(() async {
      _say("Loading configurations...");
      await app().loadConfig();

      _say("Starting internal objects...");
      await instance<AlarmingRepository>().initialize();
      await instance<BackgroundServiceRepository>().initialize();

      _say("Complete.");
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (MAIN_NAVIGATOR_KEY.currentState != null) {
          MAIN_NAVIGATOR_KEY.currentState.push(getWatchingPageRoute());
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ///APP MODEL PROVIDER
          ChangeNotifierProvider<LeAppModel>(
              create: (context) => LeAppModel()..init()),

          ///SPLASH MODEL PROVIDER
          ChangeNotifierProvider<SplashModel>(
            create: (context) => SplashModel(),
          )
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
                    )),
          );
        });
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
