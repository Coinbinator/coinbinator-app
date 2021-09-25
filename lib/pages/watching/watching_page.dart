import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page_model.dart';
import 'package:le_crypto_alerts/pages/_common/default_app_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_bottom_navigation_bar.dart';
import 'package:le_crypto_alerts/pages/_common/default_drawer.dart';
import 'package:le_crypto_alerts/pages/watching/_watch_list_view.dart';
import 'package:provider/provider.dart';

class WatchingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<WatchingPageModel>(create: (context) => WatchingPageModel()..init()),
        ],
        builder: (context, child) {
          final model = Provider.of<WatchingPageModel>(context);

          return WillPopScope(
            onWillPop: () async {
              if (model.selectingTickerWatches()) {
                model.deselectSelectedTickers();
                return false;
              }
              return true;
            },
            child: Scaffold(
              drawer: DefaultDrawer(),
              appBar: defaultAppBar(
                icon: Icons.widgets,
                title: " Watching",
                actions: _appBarActions(context),
              ),
              body: WatchListView(),
              floatingActionButton: _floatingActionButton(context),
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

  FloatingActionButton _floatingActionButton(BuildContext context) {
    final model = Provider.of<WatchingPageModel>(context);
    return null;

    if (model.selectingTickerWatches()) {
      return null;
    }

    return FloatingActionButton(
      onPressed: () => model.startAddTickerWatch(context),
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
