import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/watching/watch_list_view.dart';

import 'add_watch_dialog.dart';

class WatchingPage extends StatefulWidget {
  WatchingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WatchingPageState createState() => _WatchingPageState();
}

class _WatchingPageState extends State<WatchingPage> {
  int _counter = 0;

  void _showAddWatchForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AddWatchDialog(
              parentContext: context,
            ));

    // var app = context.findAncestorWidgetOfExactType<LeApp>();
    // app.watchListModel.addTicker(new Ticker(pair: Pair(base: "asd", quote: "qwe")));

    // () async {
    //   FlutterBackgroundService().sendData({"action": "stopService"});
    //
    //   await Future.delayed(Duration(seconds: 2));
    //   FlutterBackgroundService.initialize(LeApp.backgroundServiceOnStart);
    // }();

    // setState(() {
    //   _counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // FlatButton(onPressed: null, child: Icon(Icons.emoji_transportation_outlined)),
          // FlatButton(onPressed: null, child: Icon(Icons.sort_rounded)),
        ],
      ),
      body: WatchListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWatchForm(context),
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
