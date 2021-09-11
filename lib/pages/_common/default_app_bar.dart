import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/_common/default_linear_progress_indicator.dart';
import 'package:le_crypto_alerts/support/colors.dart';

PreferredSizeWidget defaultAppBar({
  IconData icon,
  String title = "",
  List<Widget> actions,
  bool working: false,
}) {
  return AppBar(
    actionsIconTheme: IconThemeData(
      color: LeColors.white,
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) Icon(icon),
        if (title != null && title.trim().isNotEmpty) Text(title, style: LeColors.t22b),
      ],
    ),
    actions: actions,
    bottom: DefaultLinearProgressIndicatorSized(value: working ? null : 0),
  );
}
