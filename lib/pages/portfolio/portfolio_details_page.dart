import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_model.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class PortfolioDetailsPage extends StatefulWidget {
  final int accountId;

  PortfolioDetailsPage({Key key, this.accountId}) : super(key: key);

  @override
  PortfolioDetailsPageState createState() => PortfolioDetailsPageState();
}

class PortfolioDetailsPageState extends State<PortfolioDetailsPage> {
  PortfolioDetailsModel model;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioDetailsModel>(create: (context) => (model = PortfolioDetailsModel(widget.accountId))..init()),
      ],
      builder: (context, child) {
        Provider.of<PortfolioDetailsModel>(context);

        if (!model.initialized) {
          return Container();
        }

        return RefreshIndicator(
          onRefresh: () => model.updatePortfolios(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView(
              children: [
                // Text(""
                //     " updating: ${portfolioModel.updatingPortfolios}"
                //     " last update: ${portfolioModel.updatedPortfoliosAt ?? 'unknown'}"
                //     " accounts: ${portfolioModel.portfolioResumes.length}"
                //     ""),
                _buildPortfolioHoldingsResume(),

                ///
                Table(
                  // border: TableBorder.symmetric(inside: BorderSide(width: 1, color: Colors.blue), outside: BorderSide(width: 1)),
                  columnWidths: {
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                    3: IntrinsicColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    _buildPortfolioTableHeader(),
                    for (final coin in model.portfolioResume.coins) ...[_buildPortfolioTableRow(context, coin)]
                  ],
                ),

                /// Orders
                // Table(
                //   children: [
                //     for (final order in model.orders) ...[_buildPortfolioTableRow(context, coin)]
                //       TableRow()
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortfolioHoldingsResume() {
    final double holdingsTotalAmount = model.portfolioResume.totalUsd;

    return Card(
      color: LeColors.white.shade50,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Portfolios / "${model.portfolioResume.displayName}"'),
                SelectableText('${E.currency(holdingsTotalAmount)}', maxLines: 1, style: LeColors.t26b),
              ],
            ),
            IconButton(
              // icon: Icon(model.isCardOpened(portfolio.account.id) ? Icons.chevron_right : Icons.chevron_right),
              icon: Icon(Icons.chevron_left),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildPortfolioTableHeader() {
    return TableRow(children: [
      /// SYMBOL
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Symbol', style: LeColors.t12m),
        ),
      ),

      /// VALUE
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 8, 0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text('Value', style: LeColors.t12m),
        ),
      ),
    ]);
  }

  TableRow _buildPortfolioTableRow(BuildContext context, PortfolioAccountResumeAsset coin) {
    final model = Provider.of<PortfolioDetailsModel>(context);
    final coinIndex = model.portfolioResume.coins.indexOf(coin);

    return TableRow(
      decoration: BoxDecoration(
        color: (coinIndex % 2) == 0 ? null : LeColors.grey.withAlpha(0x11),
      ),
      children: [
        /// SYMBOL
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coin.coin.symbol),
                Text(coin.coin.name, style: LeColors.t09m),
              ],
            ),
          ),
        ),

        /// VALUE
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //
              SelectableText(E.currency(coin.usdRate), maxLines: 1, style: LeColors.t22b),
              //
              Text(E.currency(coin.amount, symbol: coin.coin.symbol + " "), style: LeColors.t12m)
            ],
          ),
        ),
      ],
    );
  }
}
