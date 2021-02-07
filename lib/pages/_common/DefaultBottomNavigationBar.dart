import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/main.dart';

class DefaultBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leApp = context.findAncestorWidgetOfExactType<LeApp>();

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.widgets), label: "Watching"),
        BottomNavigationBarItem(icon: Icon(Icons.access_alarm), label: "Alerts"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Portfolio"),
      ],
      onTap: (value) {
        switch (value) {
          case 0:
            leApp.navigateToWatching(context);
            break;
          case 2:
            leApp.navigateToPortfolio(context);
            break;
        }
      },
    );
  }
}
