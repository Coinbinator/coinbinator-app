import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page_model.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class AlertsCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlertsCreatePageModel>(
            create: (context) => AlertsCreatePageModel()..init()),
      ],
      builder: (context, child) {
        final model = Provider.of<AlertsCreatePageModel>(context);

        return SimpleDialog(
          // semanticContainer: true,

          children: [
            // ListView(
            // shrinkWrap: true,
            // children: [
            /// SYMBOL / PAIR
            Column(children: [
              Text("When:"),
              ToggleButtons(
                children: [
                  for (final coin in model.commonCoins) ...[
                    Text(coin.symbol,
                        style: Theme.of(context).textTheme.headline5),
                  ],
                  Row(
                    children: [
                      if (model.userCoin != null) ...[
                        Text("${model.userCoin.name} ",
                            style: Theme.of(context).textTheme.headline5),
                        Icon(Icons.change_history_rounded),
                      ],
                      if (model.userCoin == null) ...[
                        Icon(Icons.search),
                      ],
                    ],
                  )
                ],
                isSelected: [
                  ...model.commonCoins.map((e) => e == model.selectedCoin),
                  false,
                ],
                onPressed: (index) {
                  if (index < model.commonCoins.length)
                    return model
                        .setSelectedCoin(model.commonCoins.elementAt(index));
                },
              ),
              // Text("BTC"),
            ]),

            /// PRICE LIMIT
            Column(children: [
              Text("Current at:"),
              Text("${E.currency(model.currentPrice)}"),

              ///
              Text("Reaches:"),

              Text(
                  "${E.currency(model.limitPrice)} ${E.percentageOf(model.limitPrice, model.currentPrice, decimalDigits: 2, forcePositiveSign: (model.limitPrice != model.currentPrice))}"),
              // Text("${E.percentageOf(model.limitPrice, model.currentPrice)}"),

              ToggleButtons(
                children: [
                  for (final priceLimitModifier in model.priceLimitModifiers)
                    Text(E.percentage(
                      priceLimitModifier,
                      decimalDigits: 0,
                      forcePositiveSign: priceLimitModifier != 0,
                    )),
                ],
                isSelected:
                    model.priceLimitModifiers.map((e) => false).toList(),
                onPressed: (index) => model.applyPriceLimitModifier(
                    model.priceLimitModifiers.elementAt(index)),
              ),
            ]),

            /// COMMIT & CANCEL
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    child: Text("CANCEL"),
                    onPressed: () => model.cancelAlarm(context)),
                TextButton(
                    child: Text("OK"),
                    onPressed: () => model.commitAlarm(context)),
              ],
            )
          ],
          // ),
          // ],
        );
      },
    );
  }
}
