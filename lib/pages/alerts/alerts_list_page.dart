import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_custom_scroll_view.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/pages/_common/noop_model.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page_model.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/speech/SpeechRepository.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class AlertsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AlertsListPageState();
}

class AlertsListPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoopModel>(create: (context) => null),
      ],
      builder: (context, child) {
        return Scaffold(
          drawer: DefaultDrawer(),
          appBar: defaultAppBar(
            icon: Icons.alarm,
            title: " Alarms",
            actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () => instance<SpeechRepository>().speak("Hello"))],
          ),
          body: defaultCustomScrollView(
            context: context,

            /// MENU
            menuChildren: [
              OutlinedButton(
                onPressed: () {
                  final route = getAlertCreatePageRoute(context);
                  Navigator.of(context).push(route);
                },
                child: Text("new alert"),
              ),
            ],

            /// LIST
            slivers: [
              Consumer<AlertsListPageModel>(builder: (
                BuildContext build,
                AlertsListPageModel model,
                widget,
              ) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    ///
                    DataTable(dividerThickness: 0, horizontalMargin: 4, headingRowHeight: 0, showCheckboxColumn: false, columns: [
                      DataColumn(label: Text(".")),
                      DataColumn(label: Text(".")),
                      DataColumn(label: Text("."), numeric: true),
                      DataColumn(label: Text(".")),
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
      onSelectChanged: (selected) {
        Navigator.of(context).push(getAlertEditPageRoute(context, alert));
      },
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
        DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
          if (alert.isBullish) Icon(Icons.trending_up, color: Colors.green),
          if (alert.isBearish)
            Icon(
              Icons.trending_down,
              color: Colors.red,
            ),
        ])),
        DataCell(Column(
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
        )),
        DataCell(Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: value(() {
              if (alert.isActive) return Icon(Icons.alarm_on);

              return Opacity(opacity: .4, child: Icon(Icons.alarm_on));
            }))),
      ],
    );
  }
}
