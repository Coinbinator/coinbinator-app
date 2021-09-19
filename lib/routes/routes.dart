import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_common.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_page.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page.dart';

Route getWatchingPageRoute() {
  return MaterialPageRoute(
    settings: RouteSettings(name: ROUTE_WATCHING),
    builder: (context) => WatchingPage(),
  );
}

Route getAlertListPageRoute() {
  return MaterialPageRoute(
    settings: RouteSettings(name: ROUTE_ALERTS),
    builder: (context) => AlertsListPage(),
  );
}

Route getPortifolioListPageRoute() {
  return MaterialPageRoute(
    settings: RouteSettings(name: ROUTE_PORTFOLIO),
    builder: (context) => PortfolioPage(),
  );
}

Route alertCreatePageRoute(BuildContext context) {
  return DialogRoute(
    context: context,
    useSafeArea: true,
    builder: (context) => AlertsCreatePage(),
  );
}

Route portifolioDetailsPageRoute(
    final BuildContext context, final PortfolioAccountResume portifolio) {
  assert(context != null);
  assert(portifolio != null);

  return MaterialPageRoute(
    settings: RouteSettings(
      name: ROUTE_PORTFOLIO_DETAILS,
      arguments: PortfolioDetailsRouteArguments(portifolio.account.id),
    ),
    builder: (BuildContext context) => PortfolioDetailsPage(
      accountId: portifolio.account.id,
      // accountId: Navigator.of(context) args?.portfolioId,
    ),
  );

// if (settings.name == ROUTE_PORTFOLIO_DETAILS) {
//       final args = settings.arguments as PortfolioDetailsRouteArguments;

//       assert(args != null, 'missing portfolio details argument.');

//       return ;
//     }

// WidgetBuilder builder = _getNavigatorRouteBuilder(settings);

// Navigator.of(context).pushNamed(ROUTE_PORTFOLIO_DETAILS,
//                 arguments:
//                     ;
}
