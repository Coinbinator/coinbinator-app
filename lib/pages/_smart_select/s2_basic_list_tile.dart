import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:smart_select/smart_select.dart';

// ignore: camel_case_types
class S2_BasicListTile extends StatefulWidget {
  final S2Choice choice;

  final String search;

  S2_BasicListTile({this.choice, this.search}) : super();

  @override
  _S2_BasicListTileState createState() => _S2_BasicListTileState();
}

// ignore: camel_case_types
class _S2_BasicListTileState extends State<S2_BasicListTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(MAIN_NAVIGATOR_KEY.currentContext);
    Widget title, subtitle;

    if (widget.choice.title != null)
      title = S2Text(
        text: widget.choice.title,
        style: theme.textTheme.bodyText1,
        highlight: widget.search,
        highlightColor: theme.accentColor,
      );
    if (widget.choice.subtitle != null)
      subtitle = S2Text(
        text: widget.choice.subtitle,
        style: theme.textTheme.bodyText2,
        highlight: widget.search,
        highlightColor: theme.accentColor,
      );

    return ListTile(
      onTap: () => widget.choice.select(true),
      title: title,
      subtitle: subtitle,
    );
  }
}
