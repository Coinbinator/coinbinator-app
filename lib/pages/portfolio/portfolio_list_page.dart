import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_list_model.dart';
import 'package:le_crypto_alerts/routes/routes.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class PortfolioListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PortfolioListPageState();
}

class PortfolioListPageState extends State<PortfolioListPage> {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioListModel>(create: (BuildContext context) => new PortfolioListModel()..init()),
      ],
      builder: (context, child) {
        final model = Provider.of<PortfolioListModel>(context);

        return Scaffold(
          // drawer: DefaultDrawer(),
          appBar: defaultAppBar(
            icon: Icons.account_balance_wallet,
            title: " My Portfolios",
            isWorking: model.isBusy,
            actions: [
              IconButton(icon: Icon(Icons.add), onPressed: () {}),
              IconButton(icon: Icon(Icons.refresh), onPressed: () => model.refresh()),
              IconButton(icon: Text("USD", style: LeColors.t10m), onPressed: () => model.refresh()),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => model.refresh(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ListView(
                children: [
                  ///
                  if (!model.initialized) ...[
                    Container(),
                  ] else if (model.portfolioResumes.isEmpty) ...[
                    _buildEmptyPortfolio(context),
                  ] else if (model.portfolioResumes.isNotEmpty) ...[
                    _buildPortfolioHoldingsResume(context),
                    for (final portfolio in model.portfolioResumes) ...[
                      /// Portfolio Card
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(getPortfolioDetailsPageRoute(context, portfolio)),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(portfolio.displayName, style: Theme.of(context).textTheme.headline6),
                                ),
                                // Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// EXCHANGE
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text(portfolio.displayName, style: LeColors.t18m),
                                        Text('${portfolio.coins.length} assets', style: LeColors.t12m)
                                      ],
                                    ),

                                    /// VALUE
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      // alignment: Alignment.centerRight,
                                      children: [
                                        SelectableText(E.currency(portfolio.totalUsd), maxLines: 1, style: LeColors.t18m),
                                        SelectableText(
                                          "${E.percentage(portfolio.totalUsd / model.holdingsTotalAmount)} of portfolio",
                                          maxLines: 1,
                                          style: LeColors.t12m,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          //bottomNavigationBar: DefaultBottomNavigationBar(), //NOTE: other pages had been postponed
        );
      },
    );
  }

  Widget _buildPortfolioHoldingsResume(BuildContext context) {
    final model = context.read<PortfolioListModel>();

    return Card(
      // color: LeColors.white.shade50,
      color: Theme.of(context).cardColor.withAlpha(10),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My holdings'),
            SelectableText('${E.currency(model.holdingsTotalAmount)}', maxLines: 1, style: LeColors.t26b),
          ],
        ),
      ),
    );
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

  @Deprecated('removing in favor of card list')
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

  @Deprecated('removing in favor of card list')
  DataRow _buildPortfolioDataRow(BuildContext context, PortfolioAccountResume portfolio) {
    return DataRow(
        onSelectChanged: (selected) {
          if (selected) Navigator.of(context).push(getPortfolioDetailsPageRoute(context, portfolio));
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
}
