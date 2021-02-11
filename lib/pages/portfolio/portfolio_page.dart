import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/portfolio_model.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultBottomNavigationBar.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultDrawer.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key}) : super(key: key);

  @override
  PortfolioPageState createState() => PortfolioPageState();
}

class PortfolioPageState extends State<PortfolioPage> {
  
  PortfolioModel model;

  Timer timer;

  PortfolioPageState() : super() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) => _updateWallets());
  }

  void _updateWallets() async {
    await model.updatePortfolios();
  }

  @override
  void initState() {
    super.initState();
        () async {}();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioModel>(create: (context) {
          return model = PortfolioModel()
            ..init();
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
              // leading: () {
              //   if (selectingTickers())
              //     return FlatButton(
              //       child: Icon(Icons.close),
              //       onPressed: () => deselectSelectedTickers(),
              //     );
              // }(),

              // title: () {
              //   if (selectingTickers()) return null;
              //
              //   return Text(widget.title);
              // }(),
              // ACTIONS
              // actions: [
              //   if (selectingTickers()) ...[
              //     if (allTickerSelected())
              //       FlatButton(
              //         child: Icon(Icons.check_box_outlined),
              //         onPressed: () => deselectSelectedTickers(),
              //       ),
              //     if (!allTickerSelected())
              //       FlatButton(
              //         child: Icon(Icons.check_box_outline_blank),
              //         onPressed: () => selectAllTickers(),
              //       ),
              //     FlatButton(
              //       child: Icon(Icons.delete),
              //       onPressed: () => deleteSelectedTickers(),
              //     ),
              //   ],
              //   if (!selectingTickers()) ...[
              //     DropdownButton(
              //       items: [
              //         DropdownMenuItem<String>(value: "USD", child: Text("USD")),
              //         DropdownMenuItem<String>(value: "BTC", child: Text("BTC")),
              //       ],
              //       value: "BTC",
              //       onChanged: (value) => null,
              //       // selectedItemBuilder: (context) => [ElevatedButton(child: Text("BTC"))],
              //       // child: Text("USD"),
              //       // onPressed: () => null,
              //     ),
              //   ],
              // ],
            ),
            body: GestureDetector(
              onTap: () => _updateWallets(),
              child: ListView(
                children: [
                  Text(""
                      " updating: ${portfolioModel.updatingPortfolios}"
                      " last update: ${portfolioModel.updatedPortfoliosAt ?? 'unknown'}"
                      " accounts: ${portfolioModel.portfolioResumes.length}"
                      ""),
                  for (final portfolio in portfolioModel.portfolioResumes)
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        color: Colors.amber,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(portfolio.name),
                              trailing: Text(E.currency(portfolio.totalUsd)),
                            ),
                            for (final coin in portfolio.coins) ...[
                              ListTile(
                                title: Text("(${coin.coin.symbol})"),
                                subtitle: Text("${coin.coin.name}"),
                                trailing: Text(E.currency(coin.usdRate)),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),

                  // if (wallet0 != null)
                  for (var entry in model.portfolioResumes)
                    Card(
                      child: Column(children: [
                        Text(entry.name),
                        for (var coin in entry.coins) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(coin.coin.symbol),
                              Text(E.currency(coin.usdRate, symbol: "", decimalDigits: 5)),
                            ],
                          ),
                        ],
                        // Text(entry["coin"]),
                        // Text(entry.toString()),
                      ]),
                      //     ),
                    )
                ],
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

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    print("close cron");

    if (timer != null) timer.cancel();
  }
}
