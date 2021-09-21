import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_custom_scroll_view.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page_model.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class AlertsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AlertsListPageState();
}

class AlertsListPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlertsListPageModel>(
            create: (context) => AlertsListPageModel()..init()),
      ],
      builder: (context, child) {
        debugPrint("--------------- ALERT BUILD...");
        final model = context.watch<AlertsListPageModel>();

        return Scaffold(
          drawer: DefaultDrawer(),
          appBar: defaultAppBar(
            icon: Icons.alarm,
            title: " Alarms",
            working: false,
            actions: [
              IconButton(icon: Icon(Icons.more_vert), onPressed: () => {})
            ],
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
                    ///
                    DataTable(
                        dividerThickness: 0,
                        horizontalMargin: 4,
                        headingRowHeight: 0,
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(label: Text(".")),
                          DataColumn(label: Text(".")),
                          DataColumn(label: Text("."), numeric: true),
                          DataColumn(label: Text(".")),
                        ],
                        rows: [
                          for (final alert in model.alerts) ...[
                            DataRow(
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
                                DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (alert.isBullish)
                                        Icon(Icons.trending_up,
                                            color: Colors.green),
                                      if (alert.isBearish)
                                        Icon(
                                          Icons.trending_down,
                                          color: Colors.red,
                                        ),
                                    ])),
                                DataCell(Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(E.currency(alert.limitPrice)),
                                  ],
                                )),
                                DataCell(Container(
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    child: value(() {
                                      if (_testAlertTrigger(context, alert))
                                        return Icon(Icons.alarm_on);

                                      return Opacity(
                                          opacity: .4,
                                          child: Icon(Icons.alarm_on));
                                    }))),
                              ],
                            ),
                          ],
                        ]),
                  ]),
                ),
              ]),
          bottomNavigationBar: DefaultBottomNavigationBar(),
        );
      },
    );
  }

  _testAlertTrigger(BuildContext context, AlertEntity alert) {
    final currentPrice =
        context.read<AlertsListPageModel>().coinsCurrentPrices[alert.coin];
    return alert.testTrigger(currentPrice);
  }
}
