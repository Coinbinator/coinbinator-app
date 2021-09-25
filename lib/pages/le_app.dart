import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page_model.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/pages/splash/splash_model.dart';
import 'package:le_crypto_alerts/pages/splash/splash_page.dart';
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

              /// WHY? WHY A BUILDER INSIDE A BUILDER??? You may ask...
              /// Whell the DialogRoute needs to be inside of a
              /// Locatilizations, BUT it also needs a context from inside the same Localizations
              /// and if we use the context from "MultiProvider" it will not find the nested Localizations
              /// Until I figure this out... it is what it is
              builder: (BuildContext context) => MaterialApp(
                    key: MAIN_APP_WIDGET,
                    title: 'Le Crypto Alerts',
                    navigatorKey: MAIN_NAVIGATOR_KEY,
                    theme: Provider.of<LeAppModel>(context).themeData,
                    // initialRoute: ROUTE_ROOT,
                    onGenerateInitialRoutes: _onGenerateInitialRoutes,
                    onGenerateRoute: (settings) => _onGenerateRoute(context, settings),
                  ));
        });
  }

  List<SingleChildWidget> _buildProviders(BuildContext context) {
    return [
      ///APP MODEL PROVIDER
      ChangeNotifierProvider<LeAppModel>(create: (context) => LeAppModel()..init()),

      //MAIN PROGRESS INDICATOR
      ChangeNotifierProvider<LeAppMainProgressIndicatorNotifier>(create: (context) => LeAppMainProgressIndicatorNotifier()),

      ///SPLASH MODEL PROVIDER
      ChangeNotifierProvider<SplashModel>(
        create: (context) => SplashModel(),
      ),

      /// ALERTS MODEL PROVIDER
      ChangeNotifierProvider<AlertsListPageModel>(create: (context) => AlertsListPageModel()..init()),
    ];
  }

  List<Route<dynamic>> _onGenerateInitialRoutes(String initialRoute) {
    return [
      MaterialPageRoute(builder: (_) => SplashPage()),
    ];
  }

  Route<dynamic> _onGenerateRoute(BuildContext context, RouteSettings settings) {
    /// UNKNOW
    return MaterialPageRoute(builder: (_) => Container(child: Text("Unknow Route, name: ${settings?.name}, $settings")));
  }
}
