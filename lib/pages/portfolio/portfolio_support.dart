import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/_common/default_linear_progress_indicator.dart';
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
        Text(" My Portfolios", style: LeColors.t22b),
      ],
    ),
    actions: actions,
    bottom: DefaultLinearProgressIndicatorSized(value: working ? null : 0),
  );
}
