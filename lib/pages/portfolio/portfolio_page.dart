import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/portfolio_model.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultBottomNavigationBar.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultDrawer.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultLinearProgressIndicator.dart';
import 'package:le_crypto_alerts/pages/portfolio/_portfolio_card.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key}) : super(key: key);

  @override
  PortfolioPageState createState() => PortfolioPageState();
}

class PortfolioPageState extends State<PortfolioPage> {
  PortfolioModel model;

  Timer timer;

  Future<void> _updateWallets() async {
    await model.updatePortfolios();
  }

  @override
  void initState() {
    super.initState();
    if (timer == null) {
      // timer = Timer.periodic(Duration(seconds: 15), (Timer timer) => _updateWallets());
    }

    () async {}();
  }

  @override
  @mustCallSuper
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioModel>(create: (context) {
          return model = PortfolioModel()..init();
        }),
      ],
      builder: (context, child) {
        final portfolioModel = Provider.of<PortfolioModel>(context);

        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            drawer: DefaultDrawer(),
            appBar: AppBar(
              actionsIconTheme: IconThemeData(
                color: LeColors.white,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet),
                  Text(
                    " Portfolios",
                    style: LeColors.t22b,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => model.updatePortfolios(),
                ),
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => model.updatePortfolios(),
                ),
              ],
              bottom: DefaultLinearProgressIndicatorSized(
                value: model.updatingPortfolios ? null : 0,
              ),
            ),

            body: RefreshIndicator(
              onRefresh: _updateWallets,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ListView(
                  children: [
                    // Text(""
                    //     " updating: ${portfolioModel.updatingPortfolios}"
                    //     " last update: ${portfolioModel.updatedPortfoliosAt ?? 'unknown'}"
                    //     " accounts: ${portfolioModel.portfolioResumes.length}"
                    //     ""),
                    for (final portfolio in portfolioModel.portfolioResumes) PortfolioCard(portfolio: portfolio),
                  ],
                ),
              ),
            ),
            // floatingActionButton: () {
            //   if (selectingTickers()) {
            //     return null;
            //   }
            //
            //   return FloatingActionButton(
            //     onPressed: () => showAddWatchForm(context),
            //     tooltip: 'Add Pair',
            //     child: Icon(Icons.add),
            //   );
            // }(),
            bottomNavigationBar: DefaultBottomNavigationBar(),
          ),
        );
      },
    );
  }
}
