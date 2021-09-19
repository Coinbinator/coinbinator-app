import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_custom_scroll_view.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page_model.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class AlertsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlertsListPageModel>(
            create: (context) => AlertsListPageModel()..init()),
      ],
      builder: (context, child) {
        final model = Provider.of<AlertsListPageModel>(context);

        return Scaffold(
          drawer: DefaultDrawer(),
          appBar: defaultAppBar(
            icon: Icons.alarm,
            title: " Alarms",
            working: false,
            actions: [],
          ),
          body: defaultCustomScrollView(

              /// MENU
              menuChildren: [
                OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).push(alertCreatePageRoute(context)),
                  child: Text("new alert"),
                ),
              ],

              /// LIST
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    for (final alert in model.alerts) ...[
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                      Text(
                          "when '${alert.coin}' reaches '${E.currency(alert.limitPrice)}' "),
                    ],
                    //   buildListItem(context, tickerWatch, app().tickers.getTickerFromTickerWatch(tickerWatch)),
                  ]),
                ),
              ]),
          bottomNavigationBar: DefaultBottomNavigationBar(),
        );
      },
    );
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