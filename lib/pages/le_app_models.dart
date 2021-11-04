import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/theme/color_schema_tests.dart';
import 'package:le_crypto_alerts/support/theme/theme_darker.dart';
import 'package:le_crypto_alerts/support/theme/random_color_scheme.dart';

class LeAppModel extends ChangeNotifier {
  Coin get baseCurrency => app().getBaseCurrency();

  List<AbstractExchangeAccount> accounts = [];

  List<AlertEntity> currentActiveAlerts = [];

  StreamSubscription<List<AlertEntity>> currentActiveAlertsSubscription;

  ThemeData themeData = DarkerThemeData.darker();

  void init() async {
    accounts = await app().getAccounts();

    _updateAlerts(app().alerts);
    // currentActiveAlertsSubscription =
    //     app().alertsStream.listen((alerts) => _updateAlerts(alerts));

    notifyListeners();
  }

  @override
  void dispose() {
    currentActiveAlertsSubscription.cancel();
    currentActiveAlertsSubscription = null;
    super.dispose();
  }

  void setBaseCurrency(Coin value) async {
    await app().setBaseCurrency(value);
    notifyListeners();
  }

  void _updateAlerts(List<AlertEntity> value) {
    if (value == null) return;
    currentActiveAlerts = value.where((element) => element.isActive).toList();
    notifyListeners();
  }
}

int i = 0;
ColorScheme colorSchema = colorSchemaTests()[0];

extension LeAppModel_TempThemeTests on LeAppModel {
  shufflerColors() {
    colorSchema = randomColorScheme();
    themeData = ThemeData.from(colorScheme: colorSchema);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    notifyListeners();
  }

  nextColorSchema() {
    i = (i + 1) % colorSchemaTests().length;
    colorSchema = colorSchemaTests()[i];
    ThemeData.from(colorScheme: colorSchema);

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    notifyListeners();
  }
}
