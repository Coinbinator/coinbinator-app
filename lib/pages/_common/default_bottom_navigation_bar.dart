import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:provider/provider.dart';

class _RouteInfo {
  final String routeName;

  final Route Function() routeBuilder;

  final String label;

  final Icon icon;

  final String Function(BuildContext context) notification;

  const _RouteInfo({this.routeName, this.routeBuilder, this.label, this.icon, this.notification});

  bool isExactRouteName(String value) {
    return routeName == value;
  }

  bool isNestedRouteName(String value) {
    if (routeName == null || value == null) return false;
    if (routeName == "/" && value != "/") return false;

    return value.startsWith(routeName);
  }

  BottomNavigationBarItem build(BuildContext context) {
    /// ICON
    final iconStack = Selector<LeAppModel, List<dynamic>>(
      selector: (BuildContext context, model) => [
        model.currentActiveAlerts.length,
      ],
      builder: (BuildContext context, _, model) {
        final notificationText = notification?.call(context);

        return Stack(
          children: [
            icon,
            if (notificationText != null)
              new Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    notificationText,
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );

    // BAR ITEM
    return BottomNavigationBarItem(
      icon: iconStack,
      label: label,
    );
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
    notification: (BuildContext context) {
      final currentActiveAlertsCount = Provider.of<LeAppModel>(context).currentActiveAlerts.length;
      if (currentActiveAlertsCount > 0) return "$currentActiveAlertsCount";
      return null;
    },
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
    final route = ModalRoute.of(context);
    final routeName = route?.settings?.name;

    final exactRouteInfoEntry = _routesInfosEntries.firstWhere((element) => element.value.isExactRouteName(routeName), orElse: () => null);

    final nestedRouteInfoEntry = _routesInfosEntries.firstWhere((element) => element.value.isNestedRouteName(routeName), orElse: () => null);

    return BottomNavigationBar(
      currentIndex: exactRouteInfoEntry?.key ?? nestedRouteInfoEntry?.key ?? 0,
      items: [
        for (final routeInfo in _routesInfos) routeInfo.build(context),
      ],
      onTap: (index) {
        //NOTE: ignoring same route
        if (index == exactRouteInfoEntry?.key) return;

        final route = _routesInfos[index].routeBuilder();
        final navigator = Navigator.of(context, rootNavigator: true);

        //TODO: improve bottom bar route managment

        navigator.push(route);
      },
    );
  }
}
