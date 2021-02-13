import 'package:flutter/material.dart';

const double _defaultLinearProgressIndicatorHeight = 6.0;

// ignore: must_be_immutable
class DefaultLinearProgressIndicatorSized extends LinearProgressIndicator implements PreferredSizeWidget {
  @override
  Size preferredSize;

  DefaultLinearProgressIndicatorSized({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        ) {
    preferredSize = Size(double.infinity, _defaultLinearProgressIndicatorHeight);
  }
}
