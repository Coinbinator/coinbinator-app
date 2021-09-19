import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_model.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class PortfolioDetailsPage extends StatelessWidget {
  final int accountId;

  PortfolioDetailsPage({Key key, this.accountId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioDetailsModel>(
            create: (context) =>
                PortfolioDetailsModel(context, accountId)..init()),
                
      ],
      builder: (context, child) {
        final model = context.watch<PortfolioDetailsModel>();

        // if (!model.initialized) {
        //   return Container();
        // }

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
                _buildPortfolioHoldingsResume(context),

                if (!model.initialized)
                  ...[]
                else if (model.portfolioResume == null ||
                    model.portfolioResume.coins.isEmpty) ...[
                  _buildEmptyPortfolio(context),
                ] else ...[
                  ///
                  ///
                  ///

                  Card(
                    child: Column(
                      children: [
                        ///
                        IgnorePointer(
                          child: DataTable(
                              dividerThickness: 0,
                              horizontalMargin: 4,
                              showCheckboxColumn: false,
                              columns: _buildPortfolioDataTableColumns(context),
                              rows: [
                                for (final asset
                                    in model.getPortifolioMainAssets()) ...[
                                  _buildPortfolioDataRow(context, asset),
                                ],
                              ]),
                        ),

                        ///
                        _buildToggleSubAssets(context),

                        ///
                        if (model.displaySubAssets)
                          IgnorePointer(
                            child: DataTable(
                                dividerThickness: 0,
                                horizontalMargin: 4,
                                //NOTE: we will hide this table header
                                headingRowHeight: 0,
                                showCheckboxColumn: false,
                                columns:
                                    _buildPortfolioDataTableColumns(context),
                                rows: [
                                  for (final asset
                                      in model.getPortifolioSubAssets()) ...[
                                    _buildPortfolioDataRow(context, asset),
                                  ],
                                ]),
                          ),
                      ],
                    ),
                  )

                  ///
                  ///
                  ///

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
                  //     for (final coin in model.portfolioResume.coins) ...[
                  //       _buildPortfolioTableRow(context, coin)
                  //     ]
                  //   ],
                  // ),
                ],

                ///

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

  Widget _buildPortfolioHoldingsResume(BuildContext context) {
    final model = context.watch<PortfolioDetailsModel>();

    final holdingsTotalAmount =
        model.portfolioResume == null ? 0 : model.portfolioResume.totalUsd;

    final displayName =
        model.portfolioResume == null ? "" : model.portfolioResume.displayName;

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
                ///
                if (model.portfolioResume == null) Text('My Portfolios / ...'),

                ///
                if (model.portfolioResume != null)
                  Text(
                      'My Portfolios / "${model.portfolioResume.displayName}"'),

                ///
                SelectableText('${E.currency(holdingsTotalAmount)}',
                    maxLines: 1, style: LeColors.t26b),
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

  List<DataColumn> _buildPortfolioDataTableColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text('Symbol', style: LeColors.t12m),
      ),
      DataColumn(
        numeric: true,
        label: Text('Value', style: LeColors.t12m),
      ),
    ];
  }

  DataRow _buildPortfolioDataRow(
      BuildContext context, PortfolioAccountResumeAsset asset) {
    return DataRow(selected: false,
        // onSelectChanged: (selected) {
        //   // if (selected)
        //   //   Navigator.of(context)
        //   //       .push(portifolioDetailsPageRoute(context, portfolio));
        // },
        cells: [
          /// SYMBOL
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(asset.coin.symbol, style: LeColors.t18m),
              Text(asset.coin.name, style: LeColors.t12m),
            ],
          )),

          /// VALUE
          DataCell(Align(
            alignment: Alignment.centerRight,
            child: SelectableText(
              E.currency(asset.usdRate),
              maxLines: 1,
              style: LeColors.t16m,
            ),
          )),
        ]);
  }

  Widget _buildEmptyPortfolio(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Portifolio has no assets!"),
            // ElevatedButton(onPressed: () => {}, child: Text("Add new account")),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSubAssets(BuildContext context) {
    final model = context.watch<PortfolioDetailsModel>();

    ///NOTE: no sub assets to be showun
    if (model.getPortifolioSubAssets().isEmpty && !model.displaySubAssets) {
      return Container();
    }

    return TextButton(
      onPressed: () => model.toggleDisplaySubAssets(),
      child: value(() {
        if (model.displaySubAssets) return Text("hide sub assets");
        return Text("show ${model.getPortifolioSubAssets().length} sub assets");
      }),
    );
  }

  //region DEPRECATED

  @deprecated
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

  @deprecated
  TableRow _buildPortfolioTableRow(
      BuildContext context, PortfolioAccountResumeAsset coin) {
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
              SelectableText(E.currency(coin.usdRate),
                  maxLines: 1, style: LeColors.t22b),
              //
              Text(E.currency(coin.amount, symbol: coin.coin.symbol + " "),
                  style: LeColors.t12m)
            ],
          ),
        ),
      ],
    );
  }

  //endregion

}
