import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class AddWatchDialogModel extends ChangeNotifier {
  List<Exchange> exchanges = [
    Exchange.BINANCE,
    Exchange.COINBASE,
  ];

  List<String> bases = [
    "BTC",
    "ETH",
  ];

  List<String> quotes = [
    "USDC",
    "USDT",
  ];

  Exchange selectedExchange;

  String selectedBase;

  String selectedQuote;

  selectExchange(Exchange exchange) {
    selectedExchange = exchange;
    notifyListeners();
  }

  selectBase(String base) {
    selectedBase = base;
    notifyListeners();
  }

  selectQuote(String quote) {
    selectedQuote = quote;
    notifyListeners();
  }
}

class AddWatchDialog extends StatelessWidget {
  final BuildContext parentContext;

  const AddWatchDialog({Key key, this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddWatchDialogModel>(
        create: (context) => AddWatchDialogModel(),
        builder: (context, child) {
          var model = Provider.of<AddWatchDialogModel>(context);
          var watchingPageModel = Provider.of<WatchingPageModel>(parentContext);

          return new AlertDialog(
            title: new Text("Add Pair"),
            content: Column(
              children: [
                DropdownButton(
                  items: model.exchanges
                      .map((e) => DropdownMenuItem(
                            child: Text(e.toString()),
                            value: e,
                          ))
                      .toList(),
                  value: model.selectedExchange,
                  onChanged: (value) => model.selectExchange(value),
                ),
                Row(
                  children: [
                    DropdownButton(
                      items: model.bases
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      value: model.selectedBase,
                      onChanged: (value) => model.selectBase(value),
                    ),
                    DropdownButton(
                      items: model.quotes
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      value: model.selectedQuote,
                      onChanged: (value) => model.selectQuote(value),
                    ),
                  ],
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close me!'),
                onPressed: () {
                  watchingPageModel.addTicker(new Ticker(pair: Pair(exchange: model.selectedExchange, base: model.selectedBase, quote: model.selectedQuote)));
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
