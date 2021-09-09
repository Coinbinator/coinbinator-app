import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_common.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_model.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class PortfolioListPage extends StatefulWidget {
  PortfolioListPage({Key key}) : super(key: key);

  @override
  PortfolioListPageState createState() => PortfolioListPageState();
}

class PortfolioListPageState extends State<PortfolioListPage> {
  // PortfolioListModel model;

  Timer timer;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioListModel>(create: (context) => new PortfolioListModel()..init()),
      ],
      builder: (context, child) {
        final model = Provider.of<PortfolioListModel>(context);

        return RefreshIndicator(
          onRefresh: model.refresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView(
              children: [
                // Text(""
                //     " updating: ${model.updatingPortfolios}"
                //     " last update: ${model.updatedPortfoliosAt ?? 'unknown'}"
                //     " accounts: ${model.portfolioResumes.length}"
                //     ""),
                _buildPortfolioHoldingsResume(context),
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
                    for (final portfolio in model.portfolioResumes) ...[_buildPortfolioTableRow(portfolio)]
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortfolioHoldingsResume(BuildContext context) {
    final model = Provider.of<PortfolioListModel>(context);
    final double holdingsTotalAmount = model.portfolioResumes.isEmpty ? 0 : model.portfolioResumes.map((e) => e.totalUsd).reduce((a, b) => a + b);

    return Card(
      color: LeColors.white.shade50,
      // margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My holdings'),
            SelectableText('${E.currency(holdingsTotalAmount)}', maxLines: 1, style: LeColors.t26b),
          ],
        ),
      ),
    );
  }

  TableRow _buildPortfolioTableHeader() {
    return TableRow(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text('Exchange', style: LeColors.t12m),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text('Symbols', style: LeColors.t12m),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text('Value', style: LeColors.t12m),
      ),
      Align(
        alignment: Alignment.center,
        child: Text('', style: LeColors.t18m),
      ),
    ]);
  }

  TableRow _buildPortfolioTableRow(PortfolioAccountResume portfolio) {
    return TableRow(children: [
      /// EXCHANGE
      Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(portfolio.displayName, style: LeColors.t18m),
          ],
        ),
      ),

      /// SYMBOLS
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 0, 8),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text('${portfolio.coins.length}', style: LeColors.t22b),
        ),
      ),

      /// VALUE
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 0, 8),
        child: Align(
          alignment: Alignment.centerRight,
          child: SelectableText(E.currency(portfolio.totalUsd), maxLines: 1, style: LeColors.t22b),
        ),
      ),

      /// ACTIONS
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () => Navigator.of(context).pushNamed(ROUTE_PORTFOLIO_DETAILS, arguments: PortfolioDetailsRouteArguments(portfolio.account.id)),
        ),
      ),
    ]);
  }
}
