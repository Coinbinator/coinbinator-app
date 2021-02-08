import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultBottomNavigationBar.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultDrawer.dart';
import 'package:le_crypto_alerts/pages/watching/watch_list_view.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

import 'add_watch_dialog.dart';

class WatchingPage extends StatefulWidget {
  WatchingPage({Key key, this.title = ""}) : super(key: key);

  final String title;

  @override
  WatchingPageState createState() => WatchingPageState();
}

class WatchingPageState extends State<WatchingPage> {
  Set<String> selectedTickers = Set<String>();

  bool selectingTickers() {
    if (selectedTickers.length > 0) return true;
    return false;
  }

  bool allTickerSelected() {
    var model = Provider.of<WatchingPageModel>(context);
    return selectedTickers.length == model.watchingTickers.length;
  }

  void selectTicker(Ticker ticker) {
    setState(() {
      selectedTickers.add(ticker.pair.key);
    });
  }

  void toggleTicker(Ticker ticker) {
    setState(() {
      if (selectedTickers.contains(ticker.pair.key)) {
        selectedTickers.remove(ticker.pair.key);
        return;
      }
      selectedTickers.add(ticker.pair.key);
    });
  }

  void deselectSelectedTickers() {
    setState(() {
      selectedTickers.clear();
    });
  }

  void selectAllTickers() {
    setState(() {
      var model = Provider.of<WatchingPageModel>(context, listen: false);

      model.watchingTickers.forEach((ticker) => selectedTickers.add(ticker.pair.key));
    });
  }

  void deleteSelectedTickers() {
    setState(() {
      var model = Provider.of<WatchingPageModel>(context, listen: false);

      model
          //
          .watchingTickers
          .where((ticker) => selectedTickers.contains(ticker.pair.key))
          .forEach((ticker) => model.removeWatchingTicker(ticker));

      deselectSelectedTickers();
    });
  }

  void showAddWatchForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) => AddWatchDialog(
              parentContext: context,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectingTickers()) {
          deselectSelectedTickers();
          return false;
        }
        return true;
      },
      child: Scaffold(
        drawer: DefaultDrawer(),
        appBar: AppBar(
          // LEADING
          leading: () {
            if (selectingTickers())
              return FlatButton(
                child: Icon(Icons.close),
                onPressed: () => deselectSelectedTickers(),
              );
          }(),
          // TITLE
          title: () {
            if (selectingTickers()) return null;

            return Text(widget.title);
          }(),
          // ACTIONS
          actions: [
            if (selectingTickers()) ...[
              if (allTickerSelected())
                FlatButton(
                  child: Icon(Icons.check_box_outlined),
                  onPressed: () => deselectSelectedTickers(),
                ),
              if (!allTickerSelected())
                FlatButton(
                  child: Icon(Icons.check_box_outline_blank),
                  onPressed: () => selectAllTickers(),
                ),
              FlatButton(
                child: Icon(Icons.delete),
                onPressed: () => deleteSelectedTickers(),
              ),
            ],
            if (!selectingTickers()) ...[
              DropdownButton(
                items: [
                  DropdownMenuItem<String>(value: "USD", child: Text("USD")),
                  DropdownMenuItem<String>(value: "BTC", child: Text("BTC")),
                ],
                value: "BTC",
                onChanged: (value) => null,
                // selectedItemBuilder: (context) => [ElevatedButton(child: Text("BTC"))],
                // child: Text("USD"),
                // onPressed: () => null,
              ),
            ],
          ],
        ),
        body: WatchListView(),
        floatingActionButton: () {
          if (selectingTickers()) {
            return null;
          }

          return FloatingActionButton(
            onPressed: () => showAddWatchForm(context),
            tooltip: 'Add Pair',
            child: Icon(Icons.add),
          );
        }(),
        bottomNavigationBar: DefaultBottomNavigationBar(),
      ),
    );
  }
}
