import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_model.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PortfolioPageState();
}

class PortfolioPageState extends State<PortfolioPage> {
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
            drawer: DefaultDrawer(),
            appBar: defaultAppBar(
              icon: Icons.account_balance_wallet,
              title: " My Portfolios",
              // working: model.isWorking,
              actions: [],
            ),
            body: Navigator(
              initialRoute: ROUTE_PORTFOLIO,
              onGenerateRoute: (settings) {
                WidgetBuilder builder = _getNavigatorRouteBuilder(settings);
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ),
            bottomNavigationBar: DefaultBottomNavigationBar(),
          );
        },
      ),
    );
  }

  @override
  deactivate() {
    super.deactivate();
  }

  WidgetBuilder _getNavigatorRouteBuilder(RouteSettings settings) {
    if (settings.name == ROUTE_PORTFOLIO) {
      return (BuildContext context) => PortifolioListPage();
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
