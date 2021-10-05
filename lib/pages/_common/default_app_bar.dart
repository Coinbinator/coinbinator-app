import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/_common/default_linear_progress_indicator.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/theme/theme_common.dart';
import 'package:le_crypto_alerts/support/theme/theme_darker.dart';
import 'package:provider/provider.dart';

PreferredSizeWidget defaultAppBar({
  IconData icon,
  String title = "",
  List<Widget> actions,
  bool isWorking: false,
}) {
  return AppBar(
    toolbarHeight: 40.0,
    leadingWidth: 40.0,
    titleSpacing: 2.0,
    // actionsIconTheme: IconThemeData(
    //   color: LeColors.white,
    // ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (icon != null) Icon(icon),
        if (title != null && title.trim().isNotEmpty) Text(title, style: LeColors.t22b),
      ],
    ),
    actions: actions,
    bottom: _SpecialLeAppMainProgressIndicatorConsumer(
      builder: (BuildContext context, LeAppMainProgressIndicatorNotifier model, Widget widget) => Theme(
        data: Theme.of(context).forDefaultLinearProgressIndicator(context),
        child: DefaultLinearProgressIndicatorSized(
          backgroundColor: Color(0xff2b2826),
          value: (isWorking || model.isWorking) ? null : 0,
        ),
      ),
    ),
  );
}

class _SpecialMeterial extends Material implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size(double.infinity, 6);

  _SpecialMeterial({Key key, Widget child}) : super(key: key, color: Color(0xff2b2826), elevation: 4, child: child);
}

class _SpecialLeAppMainProgressIndicatorConsumer extends Consumer<LeAppMainProgressIndicatorNotifier> implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size(double.infinity, 6);

  _SpecialLeAppMainProgressIndicatorConsumer({
    Key key,
    @required final Widget Function(BuildContext context, LeAppMainProgressIndicatorNotifier value, Widget child) builder,
    Widget child,
  })  : assert(builder != null),
        super(key: key, builder: builder, child: child);
}
