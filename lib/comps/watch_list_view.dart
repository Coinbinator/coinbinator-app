import 'package:flutter/material.dart';

class WatchListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        ...List(100).map((e) => buildCryptoListItem(context)),
      ],
    );
  }

  buildCryptoListItem(BuildContext context) {
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
                      TextSpan(style: style1, text: 'BTC'),
                      TextSpan(style: style2, text: '/'),
                      TextSpan(style: style2, text: 'usdc'),
                    ]),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(style: style3, text: 'Binance'),
                    ]),
                  ),
                ],
              ),
              Column(
                children: [
                  RichText(
                    text: TextSpan(style: style1, text: '32 7117.34'),
                  ),
                  RichText(
                    text: TextSpan(style: stylePositive, text: '"+1.4% 24h"'),
                  ),
                ],
              ),
            ],
          ),
        )
        // key: Key("0"),
        );
  }
}
