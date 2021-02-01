import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class AddWatchDialogModel extends ChangeNotifier {
  List<Exchange> exchanges = [
    Exchange.BINANCE,
    Exchange.COINBASE,
  ];

  Exchange selectedExchange = Exchange.BINANCE;

  String selectedBase = "BTC";

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

  AddWatchDialog({Key key, this.parentContext}) : super(key: key);

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
                //
                // EXCHANGE
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

                //
                // BASE ASSET
                DropdownButton(
                  items: watchingPageModel.tickers
                      .map((ticker) => ticker.pair.base)
                      .toSet()
                      .map((baseSymbol) => DropdownMenuItem(
                            child: Text(baseSymbol),
                            value: baseSymbol,
                          ))
                      .toList(),
                  value: model.selectedBase,
                  onChanged: (value) => model.selectBase(value),
                ),

                //
                // QUOTE ASSET
                DropdownButton(
                  items: watchingPageModel.tickers
                      .where((ticker) => ticker.pair.base == model.selectedBase)
                      .map((ticker) => ticker.pair.quote)
                      .toSet()
                      .map((quoteSymbol) => DropdownMenuItem(
                            child: Text(quoteSymbol),
                            value: quoteSymbol,
                          ))
                      .toList(),
                  value: model.selectedQuote,
                  onChanged: (value) => model.selectQuote(value),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close me!'),
                onPressed: () {
                  var newPairWatch = Pair(exchange: model.selectedExchange, base: model.selectedBase, quote: model.selectedQuote);
                  var newTickerWatch = new Ticker(pair: newPairWatch, price: -1, date: DateTime.fromMillisecondsSinceEpoch(0));
                  watchingPageModel.addWatchingTicker(newTickerWatch);

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
