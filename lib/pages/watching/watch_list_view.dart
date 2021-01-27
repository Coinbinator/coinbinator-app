import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class WatchListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<WatchingPageModel>(context);

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        ...model.items.map((item) => buildCryptoListItem(context, item)),
      ],
    );
  }

  Widget buildCryptoListItem(BuildContext context, Ticker ticker) {
    var style1 = Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20);
    var style2 = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16);
    var style3 = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12);

    var stylePositive = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12, color: Colors.green);
    var styleNegative = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12, color: Colors.red);

    return Card(
        margin: EdgeInsets.all(4),
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
                      TextSpan(style: style3, text: ticker.pair.exchange.toString()),
                    ]),
                  ),
                ],
              ),
              Column(
                children: [
                  RichText(
                    text: TextSpan(style: style1, text: "${ticker.price}"),
                  ),
                  RichText(
                    text: TextSpan(style: stylePositive, text: '"+1.4% 24h" ${ticker.date}'),
                    // text: TextSpan(style: stylePositive, text: '"+1.4% 24h"'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
