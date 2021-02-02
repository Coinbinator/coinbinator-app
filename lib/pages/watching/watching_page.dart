import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/watching/watch_list_view.dart';
import 'package:le_crypto_alerts/support/utils.dart';

import 'add_watch_dialog.dart';

class WatchingPage extends StatefulWidget {
  WatchingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  WatchingPageState createState() => WatchingPageState();
}

class WatchingPageState extends State<WatchingPage> {
  List<String> selectedTickers = [];

  bool selectingTickers() {
    if (selectedTickers.length > 0) return true;
    return false;
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

  void clearSelectedTickers() {
    setState(() {
      selectedTickers.clear();
    });
  }

  void showAddWatchForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AddWatchDialog(
              parentContext: context,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: () {
          if (selectingTickers()) {
            return [
              FlatButton(onPressed: null, child: Icon(Icons.delete)),
            ];
          }
          return List<Widget>();
          // FlatButton(onPressed: null, child: Icon(Icons.emoji_transportation_outlined)),
          // FlatButton(onPressed: null, child: Icon(Icons.sort_rounded)),
          // ]
        }(),
      ),
      body: WatchListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddWatchForm(context),
        tooltip: 'Add Pair',
        child: Icon(Icons.add),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.widgets), label: "Watching"),
      //     BottomNavigationBarItem(icon: Icon(Icons.access_alarm), label: "Alerts"),
      //   ],
      // ),
    );
  }
}
