import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_page.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_support.dart';
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

Route getAlertCreatePageRoute(BuildContext context) {
  return MaterialPageRoute(
    settings: RouteSettings(name: ROUTE_ALERTS_CREATE),
    builder: (context) => AlertsCreatePage(),
  );

  // return DialogRoute(
  //   context: context,
  //   settings: RouteSettings(name: ROUTE_ALERTS_CREATE),
  //   useSafeArea: true,
  //   builder: (context) => AlertsCreatePage(),
  // );
}

Future<T> showAlertEditPageRoute<T>(BuildContext context, AlertEntity alert) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => AlertsCreatePage(alert: alert),
  );

  //final route = getAlertEditPageRoute(context, alert);
  //Navigator.of(context).push(route);
}

Future<T> showAlertCreatePageRoute<T>(BuildContext context) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => AlertsCreatePage(),
  );

  //final route = getAlertCreatePageRoute(context);
  //Navigator.of(context).push(route);
}

// Route getAlertEditPageRoute(BuildContext context, AlertEntity alert) {
//   assert(alert?.id != null, "alert.id should not be null");

//   return MaterialPageRoute(
//     settings: RouteSettings(name: ROUTE_ALERTS_EDIT, arguments: alert?.id),
//     builder: (context) => AlertsCreatePage(alert: alert),
//   );

//   // return DialogRoute(
//   //   context: context,
//   //   settings: RouteSettings(name: ROUTE_ALERTS_EDIT, arguments: alert?.id),
//   //   useSafeArea: true,
//   //   builder: (context) => AlertsCreatePage(alert: alert),
//   // );
// }

Route getPortfolioListPageRoute() {
  return MaterialPageRoute(
    settings: RouteSettings(name: ROUTE_PORTFOLIO),
    builder: (context) => PortfolioListPage(),
  );
}

Route getPortfolioDetailsPageRoute(final BuildContext context, final PortfolioAccountResume portfolio) {
  assert(context != null);
  assert(portfolio != null);

  return MaterialPageRoute(
    settings: RouteSettings(
      name: ROUTE_PORTFOLIO_DETAILS,
      arguments: PortfolioDetailsRouteArguments(portfolio.account.id),
    ),
    builder: (BuildContext context) => PortfolioDetailsPage(
      accountId: portfolio.account.id,
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
