import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
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

          Container(
            width: 1000,
            height: 400,
            child: charts.PieChart(seriesList,
                animate: false,
                // Configure the width of the pie slices to 60px. The remaining space in
                // the chart will be left as a hole in the center.
                //
                // [ArcLabelDecorator] will automatically position the label inside the
                // arc if the label will fit. If the label will not fit, it will draw
                // outside of the arc with a leader line. Labels can always display
                // inside or outside using [LabelPosition].
                //
                // Text style for inside / outside can be controlled independently by
                // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
                //
                // Example configuring different styles for inside/outside:
                //       new charts.ArcLabelDecorator(
                //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60, arcRendererDecorators: [new charts.ArcLabelDecorator()])),
          ),
          // for (final coin in portfolio.coins) ...[
          //   ListTile(
          //     title: Text("(${coin.coin.symbol})"),
          //     subtitle: Text("${coin.coin.name}"),
          //     trailing: Text(E.currency(coin.usdRate)),
          //   ),
          // ]
        ],
      ),
    );
  }
}
