import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_custom_scroll_view.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/pages/_common/noop_model.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page_model.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class AlertsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AlertsListPageState();
}

class AlertsListPageState extends State<StatefulWidget> {
  final scafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoopModel>(create: (context) => null),
      ],
      builder: (context, child) {
        return Scaffold(
          key: scafoldKey,
          drawer: DefaultDrawer(),
          appBar: defaultAppBar(
            icon: Icons.alarm,
            title: " Alerts",
            actions: [
              // IconButton(icon: Icon(Icons.more_vert), onPressed: () => instance<SpeechRepository>().speak("Hello")),
              IconButton(icon: Icon(Icons.add), onPressed: () => showAlertCreatePageRoute(context)),
            ],
          ),
          body: defaultCustomScrollView(
            context: context,

            /// MENU
            // menuChildren: [
            //   OutlinedButton(
            //     onPressed: () => showAlertCreatePageRoute(context),
            //     child: Text("new alert"),
            //   ),
            // ],

            /// ITEMS
            slivers: [
              Consumer<AlertsListPageModel>(builder: (BuildContext build, AlertsListPageModel model, widget) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    ///
                    DataTable(dividerThickness: 0, horizontalMargin: 4, headingRowHeight: 0, showCheckboxColumn: false, columns: [
                      DataColumn(label: Text(".")),
                      // DataColumn(label: Text(".")),
                      DataColumn(label: Text("."), numeric: true),
                      // DataColumn(label: Text(".")),
                    ], rows: [
                      for (final alert in model.alerts) ...[
                        _buildDataRow(context, alert),
                      ],
                    ]),
                  ]),
                );
              }),
            ],
          ),
          bottomNavigationBar: DefaultBottomNavigationBar(),
        );
      },
    );
  }

  DataRow _buildDataRow(BuildContext context, AlertEntity alert) {
    final model = context.watch<AlertsListPageModel>();

    return DataRow(
      onSelectChanged: (selected) => showAlertEditPageRoute(context, alert),
      selected: alert.isActive,
      cells: [
        DataCell(Column(
          children: [
            Text(
              alert.coin.symbol,
              style: LeColors.t18m,
            ),
            Text(
              alert.coin.name,
              style: LeColors.t12m,
            ),
          ],
        )),
        // DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
        //   if (alert.isBullish) Icon(Icons.trending_up, color: Colors.green),
        //   if (alert.isBearish) Icon(Icons.trending_down, color: Colors.red),
        // ])),
        DataCell(Row(
          children: [
            // Icon(Icons.arrow_downward),
            if (alert.isBullish) Icon(Icons.arrow_upward, color: Colors.green),
            if (alert.isBearish) Icon(Icons.arrow_downward, color: Colors.red),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("l: " + E.currencyAlt(alert.limitPrice)),
                Text(
                  E.amountVariationResume(
                    prefix: 'c:',
                    amount: model.coinsCurrentPrices[alert.coin],
                    base: alert.limitPrice,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ],
        )),
        // DataCell(Container(
        //   padding: EdgeInsets.zero,
        //   margin: EdgeInsets.zero,
        //   child: value(() {
        //     if (alert.isActive) return Icon(Icons.alarm_on);

        //     return Opacity(opacity: .4, child: Icon(Icons.alarm_on));
        //   }),
        // )),
      ],
    );
  }
}
