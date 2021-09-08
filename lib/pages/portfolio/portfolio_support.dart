import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/_common/DefaultLinearProgressIndicator.dart';
import 'package:le_crypto_alerts/support/colors.dart';

PreferredSizeWidget portfolioAppBar({
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
        Icon(Icons.account_balance_wallet),
        Text(" My Portfolio", style: LeColors.t22b),
      ],
    ),
    actions: actions,
    bottom: DefaultLinearProgressIndicatorSized(value: working ? null : 0),
  );
}
