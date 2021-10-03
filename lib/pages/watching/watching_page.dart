import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';
import 'package:le_crypto_alerts/metas/pair.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/ticker_watch.dart';
import 'package:le_crypto_alerts/pages/_common/default_custom_scroll_view.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class WatchingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WatchingPageState();
}

class WatchingPageState extends State<WatchingPage> {
  final addWatchSelectKey = GlobalKey<S2SingleState<Pair>>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<WatchingPageModel>(create: (context) => WatchingPageModel()..init()),
        ],
        builder: (BuildContext context, Widget child) {
          return WillPopScope(
            onWillPop: () async {
              // if (model.selectingTickerWatches()) {
              //   model.deselectSelectedTickers();
              //   return false;
              // }
              return true;
            },
            child: Scaffold(
              drawer: DefaultDrawer(),
              appBar: defaultAppBar(
                icon: Icons.widgets,
                title: " Watching",
                actions: _appBarActions(context),
              ),
              // body: WatchListView(),
              body: defaultCustomScrollView(
                context: context,

                // MENU
                menuChildren: [
                  ..._buildMenuChildren(context),
                ],

                // ITEMS
                slivers: [
                  Consumer<WatchingPageModel>(builder: (BuildContext context, WatchingPageModel model, Widget widget) {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        for (final i in model.watchingTickers) _buildListItem(context, i, model.watchingTickerTickers[i]),
                        _buildAddTickerWatchSelect(context, model),
                      ]),
                    );
                  }),
                ],
              ),
              bottomNavigationBar: DefaultBottomNavigationBar(),
            ),
          );
        });
  }

  Widget _appBarLeading(BuildContext context) {
    final model = Provider.of<WatchingPageModel>(context);

    if (model.selectingTickerWatches()) {
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () => model.deselectSelectedTickers(),
      );
    }

    return null;
  }

  List<Widget> _appBarActions(BuildContext context) {
    
    final model = Provider.of<WatchingPageModel>(context);
    final actions = <Widget>[];

    if (model.selectingTickerWatches()) {
      if (model.allTickerWatchesSelected())
        actions.add(IconButton(
          icon: Icon(Icons.check_box_outlined),
          onPressed: () => model.deselectSelectedTickers(),
        ));

      if (!model.allTickerWatchesSelected())
        actions.add(IconButton(
          icon: Icon(Icons.check_box_outline_blank),
          onPressed: () => model.selectAllTickers(),
        ));

      actions.add(IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => model.deleteSelectedTickers(context),
      ));
    }

    if (!model.selectingTickerWatches()) {

      actions.add(IconButton(
          icon: Icon(Icons.add), //Text("new watch"),
          onPressed: () async {
            addWatchSelectKey?.currentState?.showModal();
          }));

    //   actions.add(PopupMenuButton(
    //     initialValue: "BTC",
    //     itemBuilder: (context) => [
    //       // PopupMenuCustomItem(),
    //     ],
    //     onSelected: (value) => print(value),
    //   ));
    }

    return actions;
  }

  List<Widget> _buildMenuChildren(BuildContext context) {
    return [];

    final model = Provider.of<WatchingPageModel>(context);
    final actions = <Widget>[];

    if (model.selectingTickerWatches()) {
      if (model.allTickerWatchesSelected())
        actions.add(IconButton(
          icon: Icon(Icons.check_box_outlined),
          onPressed: () => model.deselectSelectedTickers(),
        ));

      if (!model.allTickerWatchesSelected())
        actions.add(IconButton(
          icon: Icon(Icons.check_box_outline_blank),
          onPressed: () => model.selectAllTickers(),
        ));

      actions.add(IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => model.deleteSelectedTickers(context),
      ));
    }

    if (!model.selectingTickerWatches()) {
      actions.add(OutlinedButton(
          child: Text("new watch"),
          onPressed: () async {
            addWatchSelectKey?.currentState?.showModal();
          }));

      // actions.add(PopupMenuButton(
      //   initialValue: "BTC",
      //   itemBuilder: (context) => [
      //     // PopupMenuCustomItem(),
      //   ],
      //   onSelected: (value) => print(value),
      // ));
    }

    return actions;
  }

  Widget _buildListItem(
    BuildContext context,
    TickerWatch tickerWatch,
    Ticker ticker,
  ) {
    final model = Provider.of<WatchingPageModel>(context);

    //todo: mover estilos para classe centralizada de estilos
    final style1 = Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20);
    final style2 = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16);
    final style3 = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12);

    final stylePositive = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12, color: Colors.green);
    final styleNegative = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12, color: Colors.red);

    // final watchListViewModel = Provider.of<WatchListViewModel>(context, listen: true);
    // return ListTile(title: Text(tickerWatch.key));

    return GestureDetector(
      onLongPress: () {
        model.selectTickerWatch(tickerWatch);
      },
      onTap: () {
        if (model.selectingTickerWatches()) return model.toggleTickerWatch(tickerWatch);
      },
      child: Card(
          margin: EdgeInsets.all(4),
          color: model.selectedTickerWatches.contains(tickerWatch.key) ? Colors.amberAccent : null,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(style: style1, text: tickerWatch.pair.base?.symbol),
                        TextSpan(style: style2, text: '/'),
                        TextSpan(style: style2, text: tickerWatch.pair.quote?.symbol),
                      ]),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(style: style3, text: tickerWatch.exchange.name),
                      ]),
                    ),
                  ],
                ),
                Column(children: [
                  if (ticker != null) ...[
                    RichText(
                      // text: TextSpan(style: style1, text: "${E.currency(ticker.price, decimalDigits: 2, symbol: 'USD', name: 'Dolar', locale: 'en_us')}"),
                      text: TextSpan(style: style1, text: "${E.currency(ticker.closePrice, symbol: "")}"),
                    ),
                    RichText(
                      // text: TextSpan(style: stylePositive, text: '"+1.4% 24h" ${ticker.date}'),
                      // text: TextSpan(style: stylePositive, text: '"+1.4% 24h"'),
                      text: TextSpan(style: stylePositive, text: ticker.pair.quote?.symbol),
                    ),
                  ],
                ]),
              ],
            ),
          )),
    );
  }

  SmartSelect _buildAddTickerWatchSelect(BuildContext context, WatchingPageModel model) {
    return SmartSelect<Pair>.single(
      key: addWatchSelectKey,
      title: "Watch",
      value: null,
      modalFilter: true,
      modalFilterAuto: true,
      choiceItems: [
        for (final pair in model.availablePairs) S2Choice<Pair>(title: pair.toString(), value: pair),
      ],
      tileBuilder: (BuildContext context, S2SingleState<Pair> state) => Container(),
      onChange: (S2SingleState<Pair> choice) {
        model.addTickerWatch(TickerWatch(
          exchange: Exchanges.Binance,
          pair: choice.value,
        ));
      },
    );
  }
}




// class PopupMenuCustomItem extends PopupMenuEntry {
//   @override
//   State<StatefulWidget> createState() => _PopupMenuCustomItem();

//   @override
//   double get height => kMinInteractiveDimension;

//   @override
//   bool represents(value) {
//     return false;
//   }
// }

// class _PopupMenuCustomItem extends State<PopupMenuCustomItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("USD"), child: Text("Add pair watch"))),
//           ],
//         ),
//         Text("Show prices in:"),
//         Row(
//           children: [
//             Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("USD"), child: Text("USD"))),
//             Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("BTC"), child: Text("BTC"))),
//             Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("BRL"), child: Text("BRL"))),
//           ],
//         ),
//         Text("Sort by:"),
//         Row(
//           children: [
//             Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("name"), child: Text("name"))),
//             Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("price"), child: Text("price"))),
//             // FlatButton(onPressed: () => null, child: Text("BTC"), color: LeColors.accent),
//           ],
//         ),
//       ],
//     );
//   }
// }
