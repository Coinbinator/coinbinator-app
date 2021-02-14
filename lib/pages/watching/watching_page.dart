import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultBottomNavigationBar.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultDrawer.dart';
import 'package:le_crypto_alerts/pages/_common/confirm_dialog.dart';
import 'package:le_crypto_alerts/pages/watching/_watch_list_view.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

import '_add_watch_dialog.dart';

class WatchingPage extends StatefulWidget {
  @override
  WatchingPageState createState() => WatchingPageState();
}

class WatchingPageState extends State<WatchingPage> {
  WatchingPageModel get model => Provider.of<WatchingPageModel>(context, listen: false);

  Set<String> selectedTickerWatches = Set<String>();

  bool selectingTickerWatches() {
    if (selectedTickerWatches.length > 0) {
      return true;
    }
    return false;
  }

  bool allTickerWatchesSelected() {
    if (selectedTickerWatches.length == model.watchingTickers.length) {
      return true;
    }
    return false;
  }

  void selectTickerWatch(TickerWatch tickerWatch) {
    setState(() {
      selectedTickerWatches.add(tickerWatch.key);
    });
  }

  void toggleTickerWatch(TickerWatch tickerWatch) {
    setState(() {
      if (selectedTickerWatches.contains(tickerWatch.key)) {
        selectedTickerWatches.remove(tickerWatch.key);
        return;
      }
      selectedTickerWatches.add(tickerWatch.key);
    });
  }

  void deselectSelectedTickers() {
    setState(() {
      selectedTickerWatches.clear();
    });
  }

  void selectAllTickers() {
    setState(() {
      model.watchingTickers.forEach((tickerWatch) => selectedTickerWatches.add(tickerWatch.key));
    });
  }

  Future<void> deleteSelectedTickers() async {
    bool denial = !await askConfirmation(
      context,
      title: Text("Remove pair watch?"),
      content: Text("Remove ${selectedTickerWatches.length} pairs watches?"),
    );

    if (denial) {
      return;
    }

    setState(() {
      final model = Provider.of<WatchingPageModel>(context, listen: false);

      model
          //
          .watchingTickers
          .where((ticker) => selectedTickerWatches.contains(ticker.key))
          .toSet() //note: estava dando um erro de remoção durante iteração
          .forEach(
            (ticker) => model.removeTickerWatch(ticker),
          );

      deselectSelectedTickers();
    });
  }

  Future<void> startAddTickerWatch() async {
    final selectedPair = await Navigator.of(context).push(new AddWatchModal());
    if (selectedPair == null) return;

    final model = Provider.of<WatchingPageModel>(context, listen: false);
    model.addTickerWatch(TickerWatch(exchange: Exchanges.Binance, pair: selectedPair));
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WatchingPageModel>(context);

    return WillPopScope(
      onWillPop: () async {
        if (selectingTickerWatches()) {
          deselectSelectedTickers();
          return false;
        }
        return true;
      },
      child: Scaffold(
        drawer: DefaultDrawer(),
        appBar: AppBar(
          leading: _appBarLeading(),
          title: _appBarTitle(),
          actions: _appBarActions(),
        ),
        body:  WatchListView(),
        floatingActionButton: _floatingActionButton(),
        bottomNavigationBar: DefaultBottomNavigationBar(),
      ),
    );
  }

  Widget _appBarLeading() {
    if (selectingTickerWatches()) {
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () => deselectSelectedTickers(),
      );
    }

    return null;
  }

  Widget _appBarTitle() {
    if (selectingTickerWatches()) {
      return null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.widgets),
        Text(
          " Watching",
          style: LeColors.t22b,
        ),
      ],
    );
  }

  List<Widget> _appBarActions() {
    final actions = List<Widget>();

    if (selectingTickerWatches()) {
      if (allTickerWatchesSelected())
        actions.add(IconButton(
          icon: Icon(Icons.check_box_outlined),
          onPressed: () => deselectSelectedTickers(),
        ));

      if (!allTickerWatchesSelected())
        actions.add(IconButton(
          icon: Icon(Icons.check_box_outline_blank),
          onPressed: () => selectAllTickers(),
        ));

      actions.add(IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => deleteSelectedTickers(),
      ));
    }

    if (!selectingTickerWatches()) {
      actions.add(PopupMenuButton(
        initialValue: "BTC",
        itemBuilder: (context) => [
          PopupMenuCustomItem(),
        ],
        onSelected: (value) => print(value),
      ));
    }

    return actions;
  }

  FloatingActionButton _floatingActionButton() {
    return null;

    if (selectingTickerWatches()) {
      return null;
    }

    return FloatingActionButton(
      onPressed: () => startAddTickerWatch(),
      tooltip: 'Add Watch',
      child: Icon(Icons.add),
    );
  }
}

class PopupMenuCustomItem extends PopupMenuEntry {
  @override
  State<StatefulWidget> createState() => _PopupMenuCustomItem();

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(value) {
    return false;
  }
}

class _PopupMenuCustomItem extends State<PopupMenuCustomItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("USD"), child: Text("Add pair watch"))),
          ],
        ),
        Text("Show prices in:"),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("USD"), child: Text("USD"))),
            Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("BTC"), child: Text("BTC"))),
            Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("BRL"), child: Text("BRL"))),
          ],
        ),
        Text("Sort by:"),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("name"), child: Text("name"))),
            Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop("price"), child: Text("price"))),
            // FlatButton(onPressed: () => null, child: Text("BTC"), color: LeColors.accent),
          ],
        ),
      ],
    );
  }
}
