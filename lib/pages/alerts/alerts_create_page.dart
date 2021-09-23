import 'dart:math';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page_model.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/metas.dart';
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
        ChangeNotifierProvider<AlertsCreatePageModel>(
            create: (context) => AlertsCreatePageModel(widget.alert)..init()),
      ],
      builder: (context, child) {
        final model = Provider.of<AlertsCreatePageModel>(context);

        return SimpleDialog(
          children: [
            ...model.when(
              creating: () => [
                _buildCoinSelector(context),
              ],
              editing: () => [
                _buildCoinSelector(context),
              ],
            ),
            // ListView(
            // shrinkWrap: true,
            // children: [
            /// SYMBOL / PAIR

            /// PRICE LIMIT
            Column(children: [
              Text("Current at:"),
              Text("${E.currency(model.currentPrice)}"),

              ///
              Text("Reaches:"),

              Text(
                  "${E.currency(model.limitPrice)} ${E.percentageOf(model.limitPrice, model.currentPrice, decimalDigits: 2, forcePositiveSign: (model.limitPrice != model.currentPrice))}"),

              ///
              Slider(
                value: max(min(model.limitPriceVariation, 1), -1),
                min: (0.0 - 1.0),
                max: (0.0 + 1.0),
                onChanged: (value) {
                  model.limitPriceVariation = value;
                },
              ),
            ]),

            /// COMMIT & CANCEL
            ...model.when(
              creating: () => <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(child: Icon(Icons.delete), onPressed: null),
                    TextButton(
                        child: Icon(Icons.close),
                        onPressed: () => model.cancelAlarm(context)),
                    TextButton(
                        child: Icon(Icons.check),
                        onPressed: () => model.commitAlarm(context)),
                  ],
                )
              ],
              editing: () => <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        child: Icon(Icons.delete),
                        onPressed: () => model.removeAlarm(context)),
                    TextButton(
                        child: Icon(Icons.close),
                        onPressed: () => model.cancelAlarm(context)),
                    TextButton(
                        child: Icon(Icons.check),
                        onPressed: () => model.commitAlarm(context)),
                  ],
                )
              ],
            ),
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
          value: null,
          onChange: (state) => model.setSelectedCoin(state.value),
          modalFilter: true,
          modalFilterAuto: true,
          choiceItems: [
            for (final coin in Pairs.getAll()
                .where((element) =>
                    !element.base.isUSD &&
                    !element.base.isUnknown &&
                    element.quote.isUSD)
                .map((e) => e.base)
                .toSet())
              S2Choice<Coin>(
                  title: coin.symbol, subtitle: coin.name, value: coin),
          ],
          tileBuilder: (BuildContext context, S2SingleState select) =>
              TextButton(
            onPressed: () => select.showModal(),
            child: Column(
              children: [
                Text(model.selectedCoin.symbol),
                Text(model.selectedCoin.name)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
