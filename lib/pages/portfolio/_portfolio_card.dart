import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:le_crypto_alerts/models/portfolio_model.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

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
    final model = Provider.of<PortfolioModel>(context);
    return Card(
      color: LeColors.white.shade50,
      // margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(portfolio.name, style: LeColors.t18m),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(E.currency(portfolio.totalUsd), style: LeColors.t22b),
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(model.isCardOpened(portfolio.account.id) ? Icons.remove : Icons.add),
                    onPressed: () => model.toggleCardOpened(portfolio.account.id),
                  ),
                ),
              ],
            ),

            /// Coins List
            if (model.isCardOpened(portfolio.account.id) == true)
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  for (final coin in portfolio.coins)
                    TableRow(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(coin.coin.symbol),
                            Text(coin.coin.name, style: LeColors.t09m),
                          ],
                        ),
                        Align(
                            widthFactor: 1,
                            alignment: Alignment.centerRight,
                            child: Text(
                              E.currency(coin.usdRate),
                              style: LeColors.t18b,
                            )),
                      ],
                    )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
