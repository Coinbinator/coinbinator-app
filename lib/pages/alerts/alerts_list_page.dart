import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/pages/_common/default_custom_scroll_view.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page_model.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class AlertsListPage extends StatelessWidget {
  AlertsListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlertsListPageModel>(
            create: (context) => AlertsListPageModel()..init()),
      ],
      builder: (context, child) {
        final model = Provider.of<AlertsListPageModel>(context);

        return defaultCustomScrollView(
            /// MENU
            menuChildren: [
              OutlinedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(ROUTE_ALERTS_CREATE),
                child: Text("new alert 2"),
              ),
            ],

            /// LIST
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  for (final alert in model.alerts) ...[
                    Text("when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                  ],
                  //   buildListItem(context, tickerWatch, app().tickers.getTickerFromTickerWatch(tickerWatch)),
                ]),
              ),
            ]);
      },
    );
  }

  WidgetBuilder _getNavigatorRouteBuilder(RouteSettings settings) {
    // if (settings.name == ROUTE_ALERTS) {
    //   return (BuildContext context) => PortfolioListPage();
    // }
    //
    // if (settings.name == ROUTE_ALERTS_CREATE) {
    //   // final args = settings.arguments as PortfolioDetailsRouteArguments;
    //   //assert(args != null, 'missing portfolio details argument.');
    //
    //   return (BuildContext context) => PortfolioDetailsPage(
    //       // accountId: args?.portfolioId,
    //       );
    // }

    return (BuildContext context) => Container(child: Text(settings.name));
  }
}

class WatchListViewMenuDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: LeColors.white.shade50,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                //context.findAncestorStateOfType<WatchingPageState>().startAddTickerWatch();
              },
              child: Text("Add watch"),
            ),
          ],
        ),
      ),
    );
  }
}
