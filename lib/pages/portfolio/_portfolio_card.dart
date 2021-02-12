import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class PortfolioCard extends StatelessWidget {
  final PortfolioWalletResume portfolio;
  final List<charts.Series<PortfolioWalletCoin, double>> seriesList;

  PortfolioCard({this.portfolio})
      : this.seriesList = [
          if (portfolio != null)
            charts.Series<PortfolioWalletCoin, double>(
                id: "Portfolio-${portfolio.name}",
                domainFn: (datum, index) => index.toDouble(),
                measureFn: (datum, index) => datum.usdRate,
                labelAccessorFn: (datum, index) => '${datum.coin.symbol}\n${E.currency(datum.usdRate, name: '')}',
                data: [
                  for (PortfolioWalletCoin coin in portfolio.coins) coin,
                ])
        ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(portfolio.name),
            trailing: Text(E.currency(portfolio.totalUsd)),
          ),
          Table(
            children: [
              TableRow(children: [
                Center(child: Text(portfolio.name)),
                Align(alignment: Alignment.centerRight, child: Text(E.currency(portfolio.totalUsd))),
              ]),
              for (final coin in portfolio.coins)
                TableRow(
                  children: [
                    Center(child: Text(coin.coin.symbol)),
                    Align(alignment: Alignment.centerRight, child: Text(E.currency(coin.usdRate))),
                  ],
                )
            ],
          ),
          // GridView.count(
          //   shrinkWrap: true,
          //   primary: true,
          //   crossAxisCount: 3,
          //
          //   physics: NeverScrollableScrollPhysics(),
          //   children: [
          //     for (final coin in portfolio.coins)
          //       Column(
          //         children: [
          //           Text(coin.coin.symbol),
          //           Text(E.currency(coin.usdRate)),
          //         ],
          //       )
          //   ],
          // ),
          // Container(
          //   width: 1000,
          //   height: 400,
          //   child: charts.PieChart(seriesList,
          //       animate: false, defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60, arcRendererDecorators: [new charts.ArcLabelDecorator()])),
          // ),
        ],
      ),
    );
  }
}
