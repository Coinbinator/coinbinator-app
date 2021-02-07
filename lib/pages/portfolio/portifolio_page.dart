import 'dart:async';

import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultBottomNavigationBar.dart';
import 'package:le_crypto_alerts/pages/watching/watch_list_view.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/repositories/binance/binance_repository.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key}) : super(key: key);

  @override
  PortfolioPageState createState() => PortfolioPageState();
}

class PortfolioPageState extends State<PortfolioPage> {
  Timer timer;

  bool updatingPortfolio = false;

  DateTime lastUpdate;

  List wallet0;

  PortfolioPageState() : super() {
    // timer = Timer.periodic(Duration(seconds: 5), _updateWallets);
  }

  void _updateWallets(Timer timer) async {
    if (updatingPortfolio) {
      return;
    }

    setState(() {
      updatingPortfolio = true;
    });

    final apiAuthInfos = [
      BinanceApiAuthInfo(
        apiKey: app().config.test_binance_api_key,
        apiSecret: app().config.test_binance_api_secret,
      ),
    ];
  final appx = app();

    for (final apiAuthInfo in apiAuthInfos) {
      final response = await BinanceRepository(
        apiKey: apiAuthInfo.apiKey,
        apiSecret: apiAuthInfo.apiSecret,
      ).getCapitalConfigGetAll();

      setState(() {
        this.wallet0 = response;
      });
    }

    setState(() {
      updatingPortfolio = false;
      lastUpdate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = PortfolioWalletResume();
    wallet.name = "Bincance";
    wallet.coins = {
      if (wallet0 != null)
        for (var c in wallet0.where((element) {
          final free = double.parse(element["free"]);
          final total = free;

          if (total == 0) return false;
          return true;
        }))
          Coin(symbol: c['coin']): double.parse(c['free']),
    };

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
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
          onTap: () => _updateWallets(null),
          child: ListView(
            children: [
              Text("Portfolio $updatingPortfolio - " + (lastUpdate == null ? "none" : lastUpdate.toString())),
              if (wallet0 != null)
                for (var entry in [wallet])
                  Card(
                    child: Column(children: [
                      Text(entry.name),
                      for (var coin in entry.coins.keys) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(coin.symbol),
                            Text(E.currency(entry.coins[coin], symbol: "", decimalDigits: 5)),
                          ],
                        ),
                      ],
                      // Text(entry["coin"]),
                      // Text(entry.toString()),
                    ]),
                  ),
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
  }

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    print("close cron");

    if (timer != null) timer.cancel();
  }
}
