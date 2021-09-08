import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/models/portfolio_model.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultBottomNavigationBar.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultDrawer.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_common.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_support.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key}) : super(key: key);

  @override
  PortfolioPageState createState() => PortfolioPageState();
}

class PortfolioPageState extends State<PortfolioPage> {
  @override
  Widget build(BuildContext context) {
    // final portfolioModel = Provider.of<PortfolioModel>(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        drawer: DefaultDrawer(),
        appBar: portfolioAppBar(
          working: false,
          actions: [
            // IconButton(
            //   icon: Icon(Icons.refresh),
            //   onPressed: () => model.updatePortfolios(),
            // ),
            // IconButton(
            //   icon: Icon(Icons.menu),
            //   onPressed: () => model.updatePortfolios(),
            // ),
          ],
        ),
        body: Navigator(
          initialRoute: ROUTE_PORTFOLIO,
          onGenerateRoute: (settings) {
            WidgetBuilder builder = _getNavigatorRouteBuilder(settings);
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
        bottomNavigationBar: DefaultBottomNavigationBar(),
      ),
    );

    return Navigator(
      initialRoute: ROUTE_PORTFOLIO,
      onGenerateRoute: (settings) {
        WidgetBuilder builder = _getNavigatorRouteBuilder(settings);
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }

  WidgetBuilder _getNavigatorRouteBuilder(RouteSettings settings) {
    if (settings.name == ROUTE_PORTFOLIO) {
      return (BuildContext context) => PortfolioListPage();
    }

    if (settings.name == ROUTE_PORTFOLIO_DETAILS) {
      final args = settings.arguments as PortfolioDetailsRouteArguments;

      assert(args != null, 'missing portfolio details argument.');

      return (BuildContext context) => PortfolioDetailsPage(
            portfolioId: args?.portfolioId,
          );
    }

    return (BuildContext context) => Container();
    //throw Exception('Invalid route: ${settings.name}');
  }
}
