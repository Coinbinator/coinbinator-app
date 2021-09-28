import 'dart:math';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/pages/_common/confirm_dialog.dart';
import 'package:le_crypto_alerts/pages/_smart_select/s2_basic_list_tile.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page_model.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/theme/constants.dart';
import 'package:le_crypto_alerts/support/theme/theme_common.dart';
import 'package:le_crypto_alerts/support/theme/theme_darker.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class AlertsCreatePage extends StatefulWidget {
  final AlertEntity alert;

  AlertsCreatePage({Key key, this.alert}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AlertsCreatePageState();
}

class AlertsCreatePageState extends State<AlertsCreatePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlertsCreatePageModel>(create: (context) => AlertsCreatePageModel(widget.alert)..init()),
      ],
      builder: (context, child) {
        final model = Provider.of<AlertsCreatePageModel>(context);

        final body = [
          model.when(
            creating: () => Text(
              "Create alert",
              style: Theme.of(context).textTheme.headline5,
            ),
            editing: () => Text(
              "Edit alert",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8), child: Divider()),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: IntrinsicColumnWidth(flex: 1),
              1: FlexColumnWidth(10),
            },
            children: [
              _buildCoinSelector(context),
              TableRow(
                children: [Container(), Text("Current at: ${E.currency(model.selectedCoinCurrentPrice)}")],
              ),
              _buildPriceLimitTrending(context),
              _buildPriceLimitInput(context),
            ],
          ),
          Container(
            height: 10,
          ),
          _buildPageActionButtons(context),
        ];

        return Column(
          // shrinkWrap: true,
          mainAxisSize: MainAxisSize.min,
          children: [...body],
        );

        //   if (ModalRoute.of(context) is MaterialPageRoute) {
        //     return Scaffold(
        //       extendBody: false,
        //       body: Column(
        //         crossAxisAlignment: CrossAxisAlignment.stretch,
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: body,
        //       ),
        //     );
        //   }

        //   return SimpleDialog(
        //     titlePadding: DIALOG_TITLE_PADDING,
        //     title: model.when<Widget>(
        //       creating: () => Text("Create new alert"),
        //       editing: () => Text("Edit alert"),
        //     ),
        //     children: body,
        //   );
      },
    );
  }

  TableRow _buildCoinSelector(BuildContext context) {
    final model = context.watch<AlertsCreatePageModel>();
    return TableRow(
      children: [
        Text("When:", maxLines: 1, textAlign: TextAlign.right),
        IntrinsicWidth(
          child: SmartSelect<Coin>.single(
            /// SELECT --> STATE
            title: "Select a symbol",
            value: model.selectedCoin,
            onChange: (state) => model.setSelectedCoin(state.value),
            choiceItems: [
              for (final coin in model.availableCoins) S2Choice<Coin>(title: coin.symbol, subtitle: coin.name, value: coin),
            ],

            /// SELECT --> BUILDERS
            builder: S2SingleBuilder<Coin>(
              tile: (BuildContext context, S2SingleState choice) => OutlinedButton(
                onPressed: () => choice.showModal(),
                style: ButtonStyle(
                  /// This button need to have the sabe bg as the selected [ToggleButton]
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  ),
                ),
                child: Column(
                  children: [
                    Text(choice?.value?.symbol),
                    Text(choice?.value?.name),
                  ],
                ),
              ),
              choice: (BuildContext context, S2Choice choice, String search) => S2_BasicListTile(choice: choice, search: search),
            ),

            /// SELECT --> configs
            modalFilter: true,
            modalFilterAuto: true,
          ),
        ),
      ].wrapWithPadding(),
    );
  }

  TableRow _buildPriceLimitTrending(BuildContext context) {
    final model = context.watch<AlertsCreatePageModel>();

    return TableRow(
      children: [
        Text("Goes:", maxLines: 1, textAlign: TextAlign.right),
        Container(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ToggleButtons(
                constraints: BoxConstraints.expand(width: constraints.maxWidth / 2 - 2), //number 2 is number of toggle buttons
                children: [
                  Column(children: [Text("Below"), Icon(Icons.trending_down)]),
                  Column(children: [Text("Above"), Icon(Icons.trending_up)]),
                ],
                isSelected: [
                  model.limitDirection == MarketDirection.bearish,
                  model.limitDirection == MarketDirection.bullish,
                ],
                onPressed: (index) {
                  if (index == 0) model.setLimitDirection(MarketDirection.bearish);
                  if (index == 1) model.setLimitDirection(MarketDirection.bullish);
                },
              );
            },
          ),
        ),
      ].wrapWithPadding(),
    );
  }

  TableRow _buildPriceLimitInput(BuildContext context) {
    final model = context.watch<AlertsCreatePageModel>();

    return TableRow(
      children: [
        ///
        Text("Reaches:", maxLines: 1, textAlign: TextAlign.right),
        Column(
          children: [
            Text("${E.currency(model.limitPrice)}"),
            Text(
                " ${E.percentageOf(model.limitPrice, model.selectedCoinCurrentPrice, decimalDigits: 2, forcePositiveSign: (model.limitPrice != model.selectedCoinCurrentPrice))} of current price"),
            Slider(
              value: max(min(model.limitPriceVariation, model.limitPriceVariationMax), model.limitPriceVariationMin),
              min: model.limitPriceVariationMin,
              max: model.limitPriceVariationMax,
              onChanged: (value) {
                model.limitPriceVariation = value;
              },
            ),
            // Text(" ${model.limitPriceVariationMin} <= ${model.limitPriceVariation} <= ${model.limitPriceVariationMax} "),
          ],
        ),
        // Text("${E.currency(model.limitPrice)}"),

        // Text(
        //     " ${E.percentageOf(model.limitPrice, model.selectedCoinCurrentPrice, decimalDigits: 2, forcePositiveSign: (model.limitPrice != model.selectedCoinCurrentPrice))} of current price"),

        ///
      ].wrapWithPadding(),
    );
  }

  Widget _buildPageActionButtons(BuildContext context) {
    final model = context.read<AlertsCreatePageModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // REMOVE
        if (model.alert != null)
          TextButton(
              child: Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await askConfirmation(context, title: Text("Delete alert?"));
                if (confirmed) model.removeAlarm(context);
              })
        else
          TextButton(onPressed: null, child: Text("")),

        // CANCEL
        TextButton(child: Icon(Icons.close), onPressed: () => model.cancelAlarm(context)),

        // COMMIT
        TextButton(child: Icon(Icons.check), onPressed: () => model.commitAlarm(context)),
      ],
    );
  }
}

//TODO: remover e fazer de outra fomar, com composição provavelmente
extension on List<Widget> {
  List<Widget> wrapWithPadding() => [
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 4, 4), child: this.elementAt(0)),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4), child: this.elementAt(1)),
      ];
}
