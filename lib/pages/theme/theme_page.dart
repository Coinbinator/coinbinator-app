import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  ThemePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ..._buildWidgets(Theme.of(context)),
        ],
      ),
    );
  }

  List<Widget> _buildWidgets(Diagnosticable diagnosticable) {
    final props = DiagnosticPropertiesBuilder();
    diagnosticable.debugFillProperties(props);

    // ignore: unnecessary_statements
    if (diagnosticable is ThemeData) diagnosticable.debugFillProperties;

    return [
      for (final prop in props.properties) ...[
        if (prop is ColorProperty) _buildColorWidget(prop),
        // if (prop is DiagnosticsProperty<AppBarTheme>) ...[
        if (prop.value is Diagnosticable) ...[
          Text("-> ${prop.name}"),
          ..._buildWidgets(prop.value),
        ],
      ]
    ];
  }

  Widget _buildColorWidget(ColorProperty node) {
    Color color = node.value;
    if( color == null && node.defaultValue is Color) color = node.defaultValue;

    return Container(
      color: color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('@${node.name}'),
          SelectableText('#$color'),
        ],
      ),
    );
  }
}
