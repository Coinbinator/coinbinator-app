import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddWatchDialogModel extends ChangeNotifier {
  List<Exchange> exchanges = [
    Exchange.BINANCE,
    Exchange.COINBASE,
  ];

  Exchange selectedExchange = Exchange.BINANCE;

  Pair selectedPair;

  String selectedBase = "BTC";

  String selectedQuote;

  selectExchange(Exchange exchange) {
    selectedExchange = exchange;
    notifyListeners();
  }

  selectPair(Pair pair) {
    selectedPair = pair;
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

class MyDropdownMenuItem<T> extends DropdownMenuItem<T> {
  String keywords = "";

  MyDropdownMenuItem({
    Key key,
    onTap,
    value,
    @required Widget child,
    this.keywords,
  }) : super(key: key, onTap: onTap, value: value, child: child);
}

class AddWatchDialog extends StatelessWidget {
  final BuildContext parentContext;

  AddWatchDialog({Key key, this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddWatchDialogModel>(
        create: (context) => AddWatchDialogModel(),
        builder: (context, child) {
          final model = Provider.of<AddWatchDialogModel>(context);
          final watchingPageModel = Provider.of<WatchingPageModel>(parentContext);
          final pairs = watchingPageModel.tickers.map((e) => e.pair);

          return new AlertDialog(
            // backgroundColor: ,
            title: new Text("Add Watch Pair"),
            insetPadding: EdgeInsets.all(5),
            scrollable: true,
            content: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
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
                  // PAIR
                  SearchableDropdown<Pair>(
                    isCaseSensitiveSearch: false,
                    searchFn: (String keywords, List items) {
                      final fuzzy = Fuzzy(items,
                          options: FuzzyOptions<MyDropdownMenuItem<Pair>>(
                            isCaseSensitive: false,
                            keys: [
                              WeightedKey(name: "keyword", getter: (obj) => obj.keywords, weight: 1),
                            ],
                            // sortFn: (a, b) {
                            //   a.matches.first.
                            //   var al = a.matches.map((e) => e.value.length).reduce((value, element) => value + element);
                            //   var bl = b.matches.map((e) => e.value.length).reduce((value, element) => value + element);
                            //   return al < bl ? 1 : - 1;
                            // },
                            shouldSort: true,
                          ));
                      final fuzzyResult = fuzzy.search(keywords);

                      return fuzzyResult.map((e) {
                        return items.indexOf(e.item);
                      }).toList();
                    },
                    items: [
                      for (final pair in pairs)
                        MyDropdownMenuItem<Pair>(
                          keywords: "${pair.base}/${pair.quote} ${pair.base} ${pair.quote}",
                          child: Text("${pair.base}/${pair.quote}"),
                          value: pair,
                        ),
                    ],
                    // watchingPageModel.tickers
                    //     .map((ticker) => ticker.pair)
                    //     .toSet()
                    //     .map((pair) => )
                    //     .toList(),
                    onChanged: (value) => model.selectPair(value),
                    hint: Text('Search'),
                  ),

                  // DropdownButton(
                  //   items: watchingPageModel.tickers
                  //       .map((ticker) => ticker.pair.base)
                  //       .toSet()
                  //       .map((baseSymbol) => DropdownMenuItem(
                  //             child: Text(baseSymbol),
                  //             value: baseSymbol,
                  //           ))
                  //       .toList(),
                  //   value: model.selectedBase,
                  //   onChanged: (value) => model.selectBase(value),
                  // ),
                  //
                  // //
                  // // QUOTE ASSET
                  // DropdownButton(
                  //   items: watchingPageModel.tickers
                  //       .where((ticker) => ticker.pair.base == model.selectedBase)
                  //       .map((ticker) => ticker.pair.quote)
                  //       .toSet()
                  //       .map((quoteSymbol) => DropdownMenuItem(
                  //             child: Text(quoteSymbol),
                  //             value: quoteSymbol,
                  //           ))
                  //       .toList(),
                  //   value: model.selectedQuote,
                  //   onChanged: (value) => model.selectQuote(value),
                  // ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Watch'),
                onPressed: () {
                  final newPairWatch = Pair(exchange: model.selectedExchange, base: model.selectedPair.base, quote: model.selectedPair.quote);
                  final newTickerWatch = new Ticker(pair: newPairWatch, price: -1, date: DateTime.fromMillisecondsSinceEpoch(0));
                  watchingPageModel.addWatchingTicker(newTickerWatch);

                  // var newPairWatch = Pair(exchange: model.selectedExchange, base: model.selectedBase, quote: model.selectedQuote);
                  // var newTickerWatch = new Ticker(pair: newPairWatch, price: -1, date: DateTime.fromMillisecondsSinceEpoch(0));
                  // watchingPageModel.addWatchingTicker(newTickerWatch);

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
