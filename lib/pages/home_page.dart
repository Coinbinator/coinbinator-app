import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/watching/watch_list_view.dart';
import 'package:le_crypto_alerts/main.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter(BuildContext context) {
    var app = context.findAncestorWidgetOfExactType<LeApp>();
    app.watchListModel.addWatchingTicker(new Ticker(pair: Pair(base: "asd", quote: "qwe")));
    // () async {
    //   FlutterBackgroundService().sendData({"action": "stopService"});
    //
    //   await Future.delayed(Duration(seconds: 2));
    //   FlutterBackgroundService.initialize(LeApp.backgroundServiceOnStart);
    // }();

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: WatchListView(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: "Watching"),
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm), label: "Alerts"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
