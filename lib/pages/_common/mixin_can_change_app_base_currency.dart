import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/metas/coin.dart';
import 'package:le_crypto_alerts/metas/coins.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

/// Common widget utils for global "Base Currency" modification
mixin CanChangeAppBaseCurrency<T extends StatefulWidget> on State<T> {
  @protected
  final _changeAppBaseCurrencyKey = GlobalKey<S2SingleState<Coin>>();

  // ignore: non_constant_identifier_names
  appBaseCurrency_appBarButton() {
    final model = Provider.of<LeAppModel>(context);

    return IconButton(
        icon: Text(model.baseCurrency.symbol, style: LeColors.t10m),
        onPressed: () {
          assert(_changeAppBaseCurrencyKey?.currentState != null,
              'Missing changeAppBaseCurrency currentState, did you forgot to place appBaseCurrency_buildSelector() in the render list');
          _changeAppBaseCurrencyKey?.currentState?.showModal();
        });
  }

  // ignore: non_constant_identifier_names
  appBaseCurrency_buildSelector() {
    final model = Provider.of<LeAppModel>(context);
    return SmartSelect<Coin>.single(
      modalType: S2ModalType.bottomSheet,
      key: _changeAppBaseCurrencyKey,
      title: "Change currency",
      value: model.baseCurrency,
      modalFilter: false,
      modalFilterAuto: false,
      choiceItems: [
        S2Choice<Coin>(title: 'USD', value: Coins.$USD),
        S2Choice<Coin>(title: 'BRL', value: Coins.$BRL),
      ],
      tileBuilder: (BuildContext context, S2SingleState<Coin> state) => Container(),
      onChange: (S2SingleState<Coin> choice) {
        model.setBaseCurrency(choice.value);
      },
    );
  }
}
