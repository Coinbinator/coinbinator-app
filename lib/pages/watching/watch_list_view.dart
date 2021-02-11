import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class WatchListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WatchingPageModel>(context);

    return ListView(
      // scrollDirection: Axis.vertical,
      children: [
        for (final ticker in model.watchingTickers) ...[
          buildListItem(context, ticker),
          buildListItem(context, ticker),
        ],
      ],
    );
  }

  Widget buildListItem(BuildContext context, Ticker ticker) {
    final page = context.findAncestorStateOfType<WatchingPageState>();

    final style1 = Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20);
    final style2 = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16);
    final style3 = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12);

    final stylePositive = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12, color: Colors.green);
    final styleNegative = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12, color: Colors.red);

    // final watchListViewModel = Provider.of<WatchListViewModel>(context, listen: true);

    return GestureDetector(
      onLongPress: () {
        page.selectTicker(ticker);
      },
      onTap: () {
        if (page.selectingTickers()) return page.toggleTicker(ticker);
      },
      child: Card(
          margin: EdgeInsets.all(4),
          color: page.selectedTickers.contains(ticker.pair.key) ? Colors.amberAccent : null,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(style: style1, text: ticker.pair.base),
                        TextSpan(style: style2, text: '/'),
                        TextSpan(style: style2, text: ticker.pair.quote),
                      ]),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(style: style3, text: ticker.exchange.name),
                      ]),
                    ),
                  ],
                ),
                Column(
                  children: [
                    RichText(
                      // text: TextSpan(style: style1, text: "${E.currency(ticker.price, decimalDigits: 2, symbol: 'USD', name: 'Dolar', locale: 'en_us')}"),
                      text: TextSpan(style: style1, text: "${E.currency(ticker.price, symbol: "")}"),
                    ),
                    RichText(
                      // text: TextSpan(style: stylePositive, text: '"+1.4% 24h" ${ticker.date}'),
                      // text: TextSpan(style: stylePositive, text: '"+1.4% 24h"'),
                      text: TextSpan(style: stylePositive, text: ticker.pair.quote),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
