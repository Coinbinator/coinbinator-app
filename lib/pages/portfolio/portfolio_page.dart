import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultBottomNavigationBar.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultDrawer.dart';

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

    setState(() {
      updatingPortfolio = false;
      lastUpdate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {



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
          onTap: () => _updateWallets(null),
          child: ListView(
            children: [
              Text("Portfolio $updatingPortfolio - " + (lastUpdate == null ? "none" : lastUpdate.toString())),
              // if (wallet0 != null)
              //   for (var entry in [wallet])
              //     Card(
              //       child: Column(children: [
              //         Text(entry.name),
              //         for (var coin in entry.coins.keys) ...[
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(coin.symbol),
              //               Text(E.currency(entry.coins[coin], symbol: "", decimalDigits: 5)),
              //             ],
              //           ),
              //         ],
              //         // Text(entry["coin"]),
              //         // Text(entry.toString()),
              //       ]),
              //     ),
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
