import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
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

    bottom: _SpecialMaterial(
      child: Theme(
        data: Theme.of(MAIN_APP_WIDGET.currentContext).forDefaultLinearProgressIndicator(MAIN_APP_WIDGET.currentContext),
        child: DefaultLinearProgressIndicatorSized(
          backgroundColor: Color(0xff2b2826),
          value: isWorking ? null : 0,
        ),
      ),
    ),

    // bottom: _SpecialLeAppMainProgressIndicatorConsumer(
    //   builder: (BuildContext context, Le A p p M a i n P r o g r e s s I n d i c a t o r N o t i f i e r model, Widget widget) => Theme(
    //     data: Theme.of(context).forDefaultLinearProgressIndicator(context),
    //     child: DefaultLinearProgressIndicatorSized(
    //       backgroundColor: Color(0xff2b2826),
    //       value: (isWorking || model.isWorking) ? null : 0,
    //     ),
    //   ),
    // ),
  );
}

class _SpecialMaterial extends Material implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size(double.infinity, 6);

  _SpecialMaterial({Key key, Widget child}) : super(key: key, color: Color(0xff2b2826), elevation: 4, child: child);
}

// class _SpecialLeAppMainProgressIndicatorConsumer extends Consumer<L e A p p M a i n P r o g r e s s I n d i c a t o r N o t i f i er> implements PreferredSizeWidget {
//   @override
//   final Size preferredSize = Size(double.infinity, 6);

//   _SpecialLeAppMainProgressIndicatorConsumer({
//     Key key,
//     @required final Widget Function(BuildContext context, L e A p p M a i n P r o g r e s s I n d i c a t o r N o t i f i er value, Widget child) builder,
//     Widget child,
//   })  : assert(builder != null),
//         super(key: key, builder: builder, child: child);
// }
