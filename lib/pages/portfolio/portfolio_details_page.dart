import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume_asset.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/mixin_can_change_app_base_currency.dart';
import 'package:le_crypto_alerts/pages/portfolio/portfolio_details_model.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class PortfolioDetailsPage extends StatefulWidget {
  final int accountId;

  PortfolioDetailsPage({Key key, this.accountId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PortfolioDetailsPageState();
}

class PortfolioDetailsPageState extends State<PortfolioDetailsPage> with CanChangeAppBaseCurrency<PortfolioDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioDetailsModel>(create: (context) => PortfolioDetailsModel(widget.accountId)..init()),
      ],
      builder: (context, child) {
        final model = context.watch<PortfolioDetailsModel>();

        return Scaffold(
          // drawer: DefaultDrawer(),
          appBar: defaultAppBar(
            icon: Icons.account_balance_wallet,
            title: [
              if (model.portfolioResume == null) 'My Portfolios',
              if (model.portfolioResume != null) 'My Portfolios / ${model.portfolioResume.displayName}',
            ].first,
            isWorking: model.isBusy,
            actions: [
              IconButton(icon: Icon(Icons.refresh), onPressed: () => model.refresh()),
              appBaseCurrency_appBarButton(),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => model.refresh(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ListView(
                children: [
                  appBaseCurrency_buildSelector(),
                  
                  ...model.when(

                      ///
                      initialize: () => [],

                      ///
                      emptyPorfilio: () => [
                            _buildEmptyPortfolio(context),
                          ],

                      ///
                      ready: () => [
                            ///
                            _buildPortfolioHoldingsResume(context),

                            ///
                            for (final asset in model.getPortfolioMainAssets()) ...[
                              _buildPortfolioAsseetCard(context, asset),
                            ],

                            _buildSubAssetsToggle(context),

                            if (model.displaySubAssets)
                              for (final asset in model.getPortfolioSubAssets()) ...[
                                _buildPortfolioAsseetCard(context, asset),
                              ],
                          ]),
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
    final model = context.watch<PortfolioDetailsModel>();

    final holdingsTotalBaseAmount = model.portfolioResume == null ? 0 : model.portfolioResume.totalBase;

    final displayName = model.portfolioResume == null ? "" : model.portfolioResume.displayName;

    return Card(
      color: Theme.of(context).cardColor.withAlpha(10),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Portfolio market value'),

                ///
                // if (model.portfolioResume == null) Text('My Portfolios / ...'),

                ///
                // if (model.portfolioResume != null) Text('My Portfolios / "${model.portfolioResume.displayName}"'),

                ///
                SelectableText('${E.currency(holdingsTotalBaseAmount)}', maxLines: 1, style: LeColors.t26b),
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

  Widget _buildEmptyPortfolio(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Portfolio has no assets!"),
            // ElevatedButton(onPressed: () => {}, child: Text("Add new account")),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioAsseetCard(BuildContext context, PortfolioAccountResumeAsset asset) {
    final model = context.read<PortfolioDetailsModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(asset.coin.symbol, style: Theme.of(context).textTheme.headline6),
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
                    Text('${asset.amount} ${asset.coin.symbol}', style: LeColors.t12m)
                  ],
                ),

                /// VALUE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // alignment: Alignment.centerRight,
                  children: [
                    SelectableText(E.currency(asset.baseRate), maxLines: 1, style: LeColors.t18m),
                    SelectableText(
                      "${E.percentage(asset.baseRate / model.portfolioResume.totalBase)} of portfolio",
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
    );
  }

  Widget _buildSubAssetsToggle(BuildContext context) {
    final model = context.watch<PortfolioDetailsModel>();

    ///NOTE: no sub assets to be showun
    if (model.getPortfolioSubAssets().isEmpty && !model.displaySubAssets) {
      return Container();
    }

    return TextButton(
      onPressed: () => model.toggleDisplaySubAssets(),
      child: value(() {
        if (model.displaySubAssets) return Text("hide sub assets");
        return Text("show ${model.getPortfolioSubAssets().length} sub assets");
      }),
    );
  }
}
