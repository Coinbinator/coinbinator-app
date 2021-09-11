import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/colors.dart';

Widget defaultCustomScrollView({
  List<Widget> menuChildren = const <Widget>[],
  List<Widget> slivers = const <Widget>[],
}) {
  return CustomScrollView(
    slivers: [
      if (menuChildren.length > 0)
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: DefaultCustomListViewMenuDelegate(
            menuChildren: menuChildren,
          ),
        ),
      ...slivers,
// ),
//       SliverList(
//           delegate: SliverChildListDelegate([
//for (final tickerWatch in model.watchingTickers) ...[
//buildListItem(context, tickerWatch, app().tickers.getTickerFromTickerWatch(tickerWatch)),
//],
//       ]))
    ],
  );
}

class DefaultCustomListViewMenuDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 0;

  final List<Widget> menuChildren;

  DefaultCustomListViewMenuDelegate({
    this.menuChildren,
  });

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: LeColors.white.shade50,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ...menuChildren,
            // OutlinedButton(
            //   onPressed: () {
            //     //context.findAncestorStateOfType<WatchingPageState>().startAddTickerWatch();
            //   },
            //   child: Text("Add watch"),
            // ),
          ],
        ),
      ),
    );
  }
}
