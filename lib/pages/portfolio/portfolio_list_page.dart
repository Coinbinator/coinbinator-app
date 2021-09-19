import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_common.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_model.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class PortfolioListPage extends StatelessWidget {
  PortfolioListPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioListModel>(
            create: (BuildContext context) =>
                new PortfolioListModel(context)..init()),
      ],
      builder: (context, child) {
        final model = Provider.of<PortfolioListModel>(context);

        return RefreshIndicator(
          onRefresh: () => model.refresh(context),
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

                if (!model.initialized) ...[
                  Container(),
                ] else if (model.portfolioResumes.isEmpty) ...[
                  _buildEmptyPortfolio(context),
                ] else if (model.portfolioResumes.isNotEmpty) ...[
                  DataTable(
                    columns: _buildPortfolioDataTableColumns(context),
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    showCheckboxColumn: false,
                    rows: [
                      for (final portfolio in model.portfolioResumes) ...[
                        _buildPortfolioDataRow(context, portfolio),
                      ],
                    ],
                  ),
                ],
                // Table(
                //   // border: TableBorder.symmetric(inside: BorderSide(width: 1, color: Colors.blue), outside: BorderSide(width: 1)),
                //   columnWidths: {
                //     1: IntrinsicColumnWidth(),
                //     2: IntrinsicColumnWidth(),
                //     3: IntrinsicColumnWidth(),
                //   },
                //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //   children: [
                //     _buildPortfolioTableHeader(),
                //     for (final portfolio in model.portfolioResumes) ...[
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //       _buildPortfolioTableRow(portfolio),
                //     ]
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortfolioHoldingsResume(BuildContext context) {
    final model = context.read<PortfolioListModel>();
    final double holdingsTotalAmount = model.portfolioResumes.isEmpty
        ? 0
        : model.portfolioResumes.map((e) => e.totalUsd).reduce((a, b) => a + b);

    return Card(
      color: LeColors.white.shade50,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My holdings'),
            SelectableText('${E.currency(holdingsTotalAmount)}',
                maxLines: 1, style: LeColors.t26b),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildPortfolioDataTableColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text('Exchange', style: LeColors.t12m),
      ),
      DataColumn(
        numeric: true,
        label: Text('Value', style: LeColors.t12m),
      ),
    ];
  }

  DataRow _buildPortfolioDataRow(
      BuildContext context, PortfolioAccountResume portfolio) {
    return DataRow(
        onSelectChanged: (selected) {
          if (selected)
            Navigator.of(context)
                .push(portifolioDetailsPageRoute(context, portfolio));

          // if (selected)
          //   Navigator.of(context).pushNamed(ROUTE_PORTFOLIO_DETAILS,
          //       arguments:
          //           PortfolioDetailsRouteArguments(portfolio.account.id));
        },
        cells: [
          /// EXCHANGE
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(portfolio.displayName, style: LeColors.t18m),
              Text('${portfolio.coins.length} assets', style: LeColors.t12m)
            ],
          )),

          /// VALUE
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: SelectableText(E.currency(portfolio.totalUsd),
                maxLines: 1, style: LeColors.t16m),
          )),
        ]);
  }

  _buildEmptyPortfolio(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No accounts registered!"),
            ElevatedButton(onPressed: () => {}, child: Text("Add new account")),
          ],
        ),
      ),
    );
  }

  ///
  /// DEPRECATED
  ///

  @deprecated
  TableRow _buildPortfolioTableHeader() {
    return TableRow(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text('Exchange', style: LeColors.t12m),
      ),
      // Align(
      //   alignment: Alignment.centerRight,
      //   child: Text('Symbols', style: LeColors.t12m),
      // ),
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

  @deprecated
  TableRow _buildPortfolioTableRow(
      BuildContext context, PortfolioAccountResume portfolio) {
    return TableRow(children: [
      /// EXCHANGE
      Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(portfolio.displayName, style: LeColors.t18m),
            Text('${portfolio.coins.length} assets', style: LeColors.t12m)
          ],
        ),
      ),

      /// VALUE
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 0, 8),
        child: Align(
          alignment: Alignment.centerRight,
          child: SelectableText(E.currency(portfolio.totalUsd),
              maxLines: 1, style: LeColors.t16m),
        ),
      ),

      /// ACTIONS
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        child: IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () => Navigator.of(context).pushNamed(
              ROUTE_PORTFOLIO_DETAILS,
              arguments: PortfolioDetailsRouteArguments(portfolio.account.id)),
        ),
      ),
    ]);
  }
}
