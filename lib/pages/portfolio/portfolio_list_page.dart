import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_model.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class PortifolioListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PortifolioListPageState();
}

class PortifolioListPageState extends State<PortifolioListPage> {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioListModel>(create: (BuildContext context) => new PortfolioListModel(context)..init()),
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
                  Card(
                    child: Column(
                      children: [
                        DataTable(
                          dividerThickness: 0,
                          horizontalMargin: 4,
                          showCheckboxColumn: false,
                          columns: _buildPortfolioDataTableColumns(context),
                          rows: [
                            for (final portfolio in model.portfolioResumes) ...[
                              _buildPortfolioDataRow(context, portfolio),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(onPressed: () => context.read<LeAppModel>().nextColorSchema(), child: Text("(${context.read<LeAppModel>().i} + 1) next")),
                  OutlinedButton(
                      onPressed: () => context.read<LeAppModel>()
                        ..i = -1
                        ..nextColorSchema(),
                      child: Text(" reset")),
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
    final double holdingsTotalAmount = model.portfolioResumes.isEmpty ? 0 : model.portfolioResumes.map((e) => e.totalUsd).reduce((a, b) => a + b);

    return Card(
      // color: LeColors.white.shade50,
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

  DataRow _buildPortfolioDataRow(BuildContext context, PortfolioAccountResume portfolio) {
    return DataRow(
        onSelectChanged: (selected) {
          if (selected) Navigator.of(context).push(getPortifolioDetailsPageRoute(context, portfolio));
        },
        cells: [
          /// EXCHANGE
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(portfolio.displayName, style: LeColors.t18m), Text('${portfolio.coins.length} assets', style: LeColors.t12m)],
          )),

          /// VALUE
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: SelectableText(E.currency(portfolio.totalUsd), maxLines: 1, style: LeColors.t16m),
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
}
