import 'dart:math';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page_model.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/metas.dart';
import 'package:le_crypto_alerts/support/theme/constants.dart';
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

        return SimpleDialog(
          titlePadding: DIALOG_TITLE_PADDING,
          title: model.when<Widget>(
            creating: () => Text("Create new alert"),
            editing: () => Text("Edit alert"),
          ),
          children: [
            _buildCoinSelector(context),
            Column(children: [
              Text("Current at:"),
              Text("${E.currency(model.selectedCoinCurrentPrice)}"),
            ]),
            _buildPriceLimitTrending(context),
            _buildPriceLimitInput(context),
            _buildPageActionButtons(context),
          ],
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
          title: "Select a symbol",
          value: model.selectedCoin,
          onChange: (state) => model.setSelectedCoin(state.value),
          modalFilter: true,
          modalFilterAuto: true,
          choiceItems: [
            for (final coin in model.availableCoins) S2Choice<Coin>(title: coin.symbol, subtitle: coin.name, value: coin),
          ],
          tileBuilder: (BuildContext context, S2SingleState select) => OutlinedButton(
            onPressed: () => select.showModal(),
            child: Column(
              children: [
                Text(model.selectedCoin.symbol),
                Text(model.selectedCoin.name),
              ],
            ),
          ),
          builder: S2SingleBuilder<Coin>(
            choice: (BuildContext context, S2Choice choice, String search) => ListTile(
              enabled: true,
              onTap: () => choice.select(true),
              title: Text(choice.title),
              subtitle: Text(choice.subtitle),
              leading: null,
            ),
          ),
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
        //DELETE
        if (model.alert != null)
          TextButton(child: Icon(Icons.delete), onPressed: () => model.removeAlarm(context))
        else
          TextButton(
            onPressed: null,
            child: Text(""),
          ),

        TextButton(child: Icon(Icons.close), onPressed: () => model.cancelAlarm(context)),
        TextButton(child: Icon(Icons.check), onPressed: () => model.commitAlarm(context)),
      ],
    );
  }
}

class CustomThemeData {
  static of(_) {}
}
