import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/le_app.dart';

class _RouteInfo {
  final String routeName;

  final String label;

  final Icon icon;

  const _RouteInfo({this.routeName, this.label, this.icon});
}

class DefaultBottomNavigationBar extends StatelessWidget {
  static const _routesInfos = const [
    _RouteInfo(routeName: ROUTE_WATCHING, label: "Watching", icon: Icon(Icons.widgets)),
    _RouteInfo(routeName: null, label: "Alerts", icon: Icon(Icons.access_alarm)),
    _RouteInfo(routeName: ROUTE_PORTFOLIO, label: "Portfolio", icon: Icon(Icons.account_balance_wallet)),
  ];

  @override
  Widget build(BuildContext context) {
    final leApp = context.findAncestorWidgetOfExactType<LeApp>();
    final route = ModalRoute.of(context);
    final routeInfoEntry = _routesInfos.asMap().entries.firstWhere((element) => route.settings.name == element.value.routeName, orElse: () => null);
    final routeInfoIndex = routeInfoEntry?.key ?? 0;
    final routeInfo = routeInfoEntry?.value;

    return BottomNavigationBar(
      currentIndex: routeInfoIndex,
      items: [
        for (final routeInfo in _routesInfos) BottomNavigationBarItem(icon: routeInfo.icon, label: routeInfo.label),
      ],
      onTap: (index) {
        /// ignorando a mesma rota
        if (index == routeInfoIndex) return;

        /// nome da proxima rota
        final routeName = _routesInfos[index].routeName;
        if (routeName != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) {
            final isMainRoute = _routesInfos.firstWhere((element) => element.routeName == route.settings.name, orElse: () => null) != null;

            print(route);
            print(isMainRoute);
            print("");

            if (isMainRoute) return true;
            return false;
          });
          return;
        }

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
