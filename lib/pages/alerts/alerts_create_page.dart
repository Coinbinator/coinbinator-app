import 'dart:math';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/pages/_smart_select/s2_basic_list_tile.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page_model.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/theme/constants.dart';
import 'package:le_crypto_alerts/support/theme/theme_common.dart';
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
          _buildCoinSelector(context),
          Column(children: [
            Text("Current at:"),
            Text("${E.currency(model.selectedCoinCurrentPrice)}"),
          ]),
          _buildPriceLimitTrending(context),
          _buildPriceLimitInput(context),
          _buildPageActionButtons(context),
        ];

        if (ModalRoute.of(context) is MaterialPageRoute) {
          return Scaffold(
            extendBody: true,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: body,
            ),
          );
        }

        return SimpleDialog(
          titlePadding: DIALOG_TITLE_PADDING,
          title: model.when<Widget>(
            creating: () => Text("Create new alert"),
            editing: () => Text("Edit alert"),
          ),
          children: body,
        );
      },
    );
  }

  Widget _buildCoinSelector(BuildContext context) {
    final model = context.watch<AlertsCreatePageModel>();
    return Column(
      children: [
        Text("When"),
        SmartSelect<Coin>.single(
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
      ],
    );
  }

  Widget _buildPriceLimitTrending(BuildContext context) {
    final model = context.watch<AlertsCreatePageModel>();

    return Column(
      children: [
        Text("Goes"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ToggleButtons(
            // borderRadius: BorderRadius.all(Radius.circular(4)),
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
          ),
        ]),
      ],
    );
  }

  Widget _buildPriceLimitInput(BuildContext context) {
    final model = context.watch<AlertsCreatePageModel>();

    return Column(children: [
      ///
      Text("Reaches:"),

      Text("${E.currency(model.limitPrice)}"),

      Text(
          " ${E.percentageOf(model.limitPrice, model.selectedCoinCurrentPrice, decimalDigits: 2, forcePositiveSign: (model.limitPrice != model.selectedCoinCurrentPrice))} of current price"),

      ///
      Slider(
        value: max(min(model.limitPriceVariation, 1), -1),
        min: (0.0 - 1.0),
        max: (0.0 + 1.0),
        onChanged: (value) {
          model.limitPriceVariation = value;
        },
      ),
    ]);
  }

  Widget _buildPageActionButtons(BuildContext context) {
    final model = context.read<AlertsCreatePageModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // REMOVE
        if (model.alert != null)
          TextButton(child: Icon(Icons.delete), onPressed: () => model.removeAlarm(context))
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

class CustomThemeData {
  static of(_) {}
}
