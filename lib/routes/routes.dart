import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_list_page.dart';

Route alertListPageRoute(BuildContext context) {
  return MaterialPageRoute(
    builder: (context) => AlertsListPage(),
  );
}

Route alertCreatePageRoute(BuildContext context) {
  return DialogRoute(
    context: context,
    builder: (context) => AlertsCreatePage(),
  );
}
