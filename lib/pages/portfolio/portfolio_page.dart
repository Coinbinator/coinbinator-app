import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_model.dart';
import 'package:le_crypto_alerts/support/leapp_navigator_observer.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PortfolioPageState();
}

final portfolioNavigatorObserver = LeAppNavigatorObserver();

class PortfolioPageState extends State<PortfolioPage> with LeAppNavigatorAware {
  String currentRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    leAppRouteObserver.subscribe(this);
    portfolioNavigatorObserver.subscribe(this);
  }

  @override
  dispose() {
    leAppRouteObserver.unsubscribe(this);
    portfolioNavigatorObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChange(Route<dynamic> route, Route<dynamic> previousRoute) {
    // print('POPOP  ${previousRoute?.settings?.name ?? ''} ==>  ${route?.settings?.name ?? ''} ');

    currentRoute = route?.settings?.name;

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: ChangeNotifierProvider<PortfolioModel>(
        create: (BuildContext context) => PortfolioModel(),
        builder: (BuildContext context, _) {
          return Scaffold(
            // drawer: DefaultDrawer(),
            appBar: defaultAppBar(
              icon: Icons.account_balance_wallet,
              title: " My Portfolios",
              // working: model.isWorking,
              actions: [
                if (currentRoute == ROUTE_PORTFOLIO) ...[
                  IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
                  IconButton(icon: Icon(Icons.add), onPressed: () {}),
                ],
                if (currentRoute == ROUTE_PORTFOLIO_DETAILS) ...[
                  IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
                ],
              ],
            ),
            body: Navigator(
              initialRoute: ROUTE_PORTFOLIO,
              observers: [portfolioNavigatorObserver],
              onGenerateRoute: (settings) {
                WidgetBuilder builder = _getNavigatorRouteBuilder(settings);
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ),
            bottomNavigationBar: DefaultBottomNavigationBar(), //NOTE: other pages had been postponed
          );
        },
      ),
    );
  }

  WidgetBuilder _getNavigatorRouteBuilder(RouteSettings settings) {
    if (settings.name == ROUTE_PORTFOLIO) {
      return (BuildContext context) => PortfolioListPage();
    }

    // if (settings.name == ROUTE_PORTFOLIO_DETAILS) {
    //   final args = settings.arguments as PortfolioDetailsRouteArguments;

    //   assert(args != null, 'missing portfolio details argument.');

    //   return (BuildContext context) => PortfolioDetailsPage(
    //         accountId: args?.portfolioId,
    //       );
    // }

    return (BuildContext context) => Container(child: Text("Route not found: ${settings.name}"));
    //throw Exception('Invalid route: ${settings.name}');
  }
}
