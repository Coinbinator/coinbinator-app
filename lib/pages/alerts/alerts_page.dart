import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page.dart';

class AlertsPage extends StatefulWidget {
  AlertsPage({Key key}) : super(key: key);

  @override
  AlertsPageState createState() => AlertsPageState();
}

class AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        drawer: DefaultDrawer(),
        appBar: defaultAppBar(
          icon: Icons.alarm,
          title: " Alarms",
          working: false,
          actions: [],
        ),
        body: Navigator(
          initialRoute: ROUTE_ALERTS,
          onGenerateRoute: (settings) {
            WidgetBuilder builder = _getNavigatorRouteBuilder(settings);
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
        bottomNavigationBar: DefaultBottomNavigationBar(),
      ),
    );
  }

  WidgetBuilder _getNavigatorRouteBuilder(RouteSettings settings) {
    if (settings.name == ROUTE_ALERTS) {
      return (BuildContext context) => AlertsListPage();
    }

    if (settings.name == ROUTE_ALERTS_CREATE) {
      return (BuildContext context) => AlertsCreatePage();
    }

    return (BuildContext context) => Container(child: Text(settings.name));
  }
}
