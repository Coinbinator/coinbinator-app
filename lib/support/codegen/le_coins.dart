import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' as cb;
import 'package:dart_style/dart_style.dart' as ds;
import 'package:dio/dio.dart';
import 'package:source_gen/source_gen.dart';

class LeCoinsAnnotation {
  const LeCoinsAnnotation();
}

class LeCoinsGenerator extends GeneratorForAnnotation<LeCoinsAnnotation> {
  @override
  Future<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {
    final exchangeInfo = await Dio().get("https://api.binance.com/api/v3/exchangeInfo", options: RequestOptions(responseType: ResponseType.json));
    final symbols = exchangeInfo.data["symbols"] as List;
    final coins = [
      for (final e in symbols) ...[
        e["baseAsset"],
        e["quoteAsset"],
      ]
    ].toSet().toList();

    /// the class

    final emitter = cb.DartEmitter();
    final coinsClass = cb.Class((c) {
      c.name = "Coins";

      // Get Coin
      c.methods.add(cb.Method.returnsVoid((m) => m
        ..name = "getCoin"
        ..static = true
        ..returns = cb.refer("Coin")
        ..requiredParameters.add(cb.Parameter((p) => p
          ..name = "value"
          ..type = cb.refer("String")))
        ..lambda = true
        ..body = cb.Code("_getCoin(value)")));


      for (final coin in coins) {
        final field = cb.FieldBuilder()
          ..name = "\$$coin"
          ..static = true
          ..modifier = cb.FieldModifier.constant
          ..assignment = cb.Code('const Coin(name:"$coin", symbol:"$coin")');

        c.fields.add(field.build());
      }

      final allCoinsField = cb.FieldBuilder()
        ..name = "_coins"
        ..static = true
        ..modifier = cb.FieldModifier.constant
        ..assignment = cb.Code([
          "{",
          coins.map((coin) => '"$coin": \$$coin').join(",\n"),
          "}",
        ].join("\n"));

      c.fields.add(allCoinsField.build());

      return c;
    });

    return ds.DartFormatter().format('${coinsClass.accept(emitter)}');
  }
}

Builder leCoinsBuilder(BuilderOptions options) => PartBuilder([LeCoinsGenerator()], '.le.dart');
