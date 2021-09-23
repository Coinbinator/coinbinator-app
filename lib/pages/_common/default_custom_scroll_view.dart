import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/colors.dart';

Widget defaultCustomScrollView({
  @required BuildContext context,
  List<Widget> menuChildren = const <Widget>[],
  List<Widget> Function(BuildContext context) menuChildrenBuilder,
  List<Widget> slivers = const <Widget>[],
  List<Widget> Function(BuildContext context) sliversBuilder,
}) {
  return CustomScrollView(
    slivers: [
      if (menuChildren.length > 0)
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: _DefaultCustomListViewMenuDelegate(
            menuChildren: menuChildren,
            menuChildrenBuilder: menuChildrenBuilder,
          ),
        ),
      ...slivers,
      if (sliversBuilder != null) ...sliversBuilder(context)
    ],
  );
}

class _DefaultCustomListViewMenuDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 0;

  final List<Widget> menuChildren;

  List<Widget> Function(BuildContext context) menuChildrenBuilder;

  _DefaultCustomListViewMenuDelegate({
    this.menuChildren,
    this.menuChildrenBuilder,
  });

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: LeColors.white.shade50,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ...menuChildren,
            if (menuChildrenBuilder != null) ...menuChildrenBuilder(context),
          ],
        ),
      ),
    );
  }
}
