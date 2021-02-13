import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/models/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultBottomNavigationBar.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultDrawer.dart';
import 'package:le_crypto_alerts/pages/watching/watch_list_view.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

import '_add_watch_dialog.dart';

class WatchingPage extends StatefulWidget {
  WatchingPage({Key key, this.title = ""}) : super(key: key);

  final String title;

  @override
  WatchingPageState createState() => WatchingPageState();
}

class WatchingPageState extends State<WatchingPage> {
  Set<String> selectedTickers = Set<String>();

  WatchingPageModel get model => Provider.of<WatchingPageModel>(context);

  bool selectingTickers() {
    if (selectedTickers.length > 0) {
      return true;
    }
    return false;
  }

  bool allTickerSelected() {
    if (selectedTickers.length == model.watchingTickers.length) {
      return true;
    }

    return false;
  }

  void selectTicker(Ticker ticker) {
    setState(() {
      selectedTickers.add(ticker.key);
    });
  }

  void toggleTicker(Ticker ticker) {
    setState(() {
      if (selectedTickers.contains(ticker.key)) {
        selectedTickers.remove(ticker.key);
        return;
      }
      selectedTickers.add(ticker.key);
    });
  }

  void deselectSelectedTickers() {
    setState(() {
      selectedTickers.clear();
    });
  }

  void selectAllTickers() {
    setState(() {
      model.watchingTickers.forEach((ticker) => selectedTickers.add(ticker.key));
    });
  }

  void deleteSelectedTickers() {
    setState(() {
      model.watchingTickers.where((ticker) => selectedTickers.contains(ticker.key)).forEach((ticker) => model.removeWatchingTicker(ticker));
      deselectSelectedTickers();
    });
  }

  void showAddWatchForm(BuildContext context) {

    Navigator.of(context).push(new AddWatchModal());

    // showModalBottomSheet(context: context, builder: (_) => AddWatchDialog(parentContext: context));
    // showDialog(context: context, builder: (_) => AddWatchDialog(parentContext: context));
    // showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AddWatchDialog(parentContext: context),);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WatchingPageModel>(create: (context) => WatchingPageModel()),
      ],
      builder: (context, child) {
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
      },
    );
  }
}
