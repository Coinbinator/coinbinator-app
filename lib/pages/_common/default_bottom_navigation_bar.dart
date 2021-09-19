import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class _RouteInfo {
  final String routeName;

  final Route Function() routeBuilder;

  final String label;

  final Icon icon;

  const _RouteInfo({this.routeName, this.routeBuilder, this.label, this.icon});

  bool isExactRouteName(String value) {
    return routeName == value;
  }

  bool isNestedRouteName(String value) {
    if (routeName == null || value == null) return false;
    if (routeName == "/" && value != "/") return false;

    return value.startsWith(routeName);
  }
}

final _routesInfos = [
  _RouteInfo(
    routeName: ROUTE_WATCHING,
    routeBuilder: getWatchingPageRoute,
    label: "Watching",
    icon: Icon(Icons.widgets),
  ),
  _RouteInfo(
    routeName: ROUTE_ALERTS,
    routeBuilder: getAlertListPageRoute,
    label: "Alerts",
    icon: Icon(Icons.access_alarm),
  ),
  _RouteInfo(
    routeName: ROUTE_PORTFOLIO,
    routeBuilder: getPortifolioListPageRoute,
    label: "My Portfolios",
    icon: Icon(Icons.account_balance_wallet),
  ),
];

final _routesInfosEntries = _routesInfos.asMap().entries;

class DefaultBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leApp = context.findAncestorWidgetOfExactType<LeApp>();
    final route = ModalRoute.of(context);
    final routeName = route.settings.name;

    final exactRouteInfoEntry = _routesInfosEntries.firstWhere(
        (element) => element.value.isExactRouteName(routeName),
        orElse: () => null);
    final nestedRouteInfoEntry = _routesInfosEntries.firstWhere(
        (element) => element.value.isNestedRouteName(routeName),
        orElse: () => null);

    return BottomNavigationBar(
      currentIndex: exactRouteInfoEntry?.key ?? nestedRouteInfoEntry?.key ?? 0,
      items: [
        for (final routeInfo in _routesInfos)
          BottomNavigationBarItem(icon: routeInfo.icon, label: routeInfo.label),
      ],
      onTap: (index) {
        /// ignorando a mesma rota
        if (index == exactRouteInfoEntry?.key) return;

        final route = _routesInfos[index].routeBuilder();
        if (route != null)
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            route,
            (route) {
              final isMainRoute = _routesInfos.firstWhere(
                      (element) =>
                          element.isExactRouteName(route.settings.name),
                      orElse: () => null) !=
                  null;

              if (isMainRoute) return true;
              return false;
            },
          );

        /// nome da proxima rota
        // final routeName = _routesInfos[index].routeName;

        // if (routeName != null) {

        // Navigator.of(context, rootNavigator: true)
        //     .pushNamedAndRemoveUntil(routeName, (route) {
        //   final isMainRoute = _routesInfos.firstWhere(
        //           (element) => element.routeName == route.settings.name,
        //           orElse: () => null) !=
        //       null;

        //   // print(route);
        //   // print(isMainRoute);
        //   // print("");

        //   if (isMainRoute) return true;
        //   return false;
        // });

        // print("DefaultBottomNavigationBar:");
        // print("  Unknown route at index: $index. ($routeName)");
        // return;
        // }

        // switch (value) {
        //   case 0:
        //     leApp.navigateToWatching(context);
        //     break;
        //   case 2:
        //     leApp.navigateToPortfolio(context);
        //     break;
        // }
      },
    );
  }
}
