import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/_common/default_linear_progress_indicator.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:provider/provider.dart';

PreferredSizeWidget defaultAppBar({
  IconData icon,
  String title = "",
  List<Widget> actions,
  // bool working: false,
}) {
  return AppBar(
    // actionsIconTheme: IconThemeData(
    //   color: LeColors.white,
    // ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) Icon(icon),
        if (title != null && title.trim().isNotEmpty)
          Text(title, style: LeColors.t22b),
      ],
    ),
    actions: actions,
    bottom: _SpecialLeAppMainProgressIndicatorConsumer(
      builder: (BuildContext context, LeAppMainProgressIndicatorNotifier model,
              Widget widget) =>
          DefaultLinearProgressIndicatorSized(
              value: model.isWorking ? null : 0),
    ),
  );
}

class _SpecialLeAppMainProgressIndicatorConsumer
    extends Consumer<LeAppMainProgressIndicatorNotifier>
    implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size(double.infinity, 6);

  _SpecialLeAppMainProgressIndicatorConsumer({
    Key key,
    @required
        final Widget Function(BuildContext context,
                LeAppMainProgressIndicatorNotifier value, Widget child)
            builder,
    Widget child,
  })  : assert(builder != null),
        super(key: key, builder: builder, child: child);
}
