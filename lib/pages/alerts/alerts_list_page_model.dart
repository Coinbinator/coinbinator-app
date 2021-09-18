import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/pages/alerts/alerts_create_page.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

class AlertsListPageModel extends ChangeNotifier {
  Stream<List<AlertEntity>> alertsStream;
  StreamSubscription<List<AlertEntity>> alertsStreamSubscription;
  List<AlertEntity> alerts = [];
  Set<AlertEntity> selectedAlerts = {};

  init() async {
    this.alertsStream = app().appDao.findAllAlertsAsStream();
    this.alertsStreamSubscription = this.alertsStream.listen((event) {
      this.alerts = event;
      notifyListeners();
    });
    this.alerts = await this.alertsStream.first;
  }

  dispose() {
    super.dispose();
    this.alertsStreamSubscription.cancel();
  }

  // void showAddAlert(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertsCreatePage(),
  //     barrierDismissible: true,
  //   );
  // }
}
