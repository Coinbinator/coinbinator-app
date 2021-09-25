import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' as cb;
import 'package:dart_style/dart_style.dart' as ds;
import 'package:le_crypto_alerts/support/codegen/le_coins_annotations.dart';
import 'package:source_gen/source_gen.dart';
import 'dart:io';

//TODO: renomear e mover esse arquivo
//TODO: testar uso dos coins no registro dos pares

class _LeCoinsGeneratorCoin {
  final String name;
  final String symbol;

  const _LeCoinsGeneratorCoin({this.symbol, this.name});
}

class _LePairGeneratorCoin {
  final String base;
  final String quote;

  const _LePairGeneratorCoin({this.base, this.quote});
}

List<_LeCoinsGeneratorCoin> _loadKnownCoins() {
  final coinsJson = File.fromRawPath(utf8.encode("meta/known_coins.json")).readAsStringSync();
  final coins = (json.decode(coinsJson) as List).map((e) => _LeCoinsGeneratorCoin(symbol: e["coin"], name: e["name"])).toList();
  return coins;
}

List<_LePairGeneratorCoin> _loadKnownPairs() {
  final pairsJson = File.fromRawPath(utf8.encode("meta/known_pairs.json")).readAsStringSync();
  final pairs = (json.decode(pairsJson) as List).map((e) => _LePairGeneratorCoin(base: e["base"], quote: e["quote"])).toList();
  return pairs;
}

class LeCoinsGenerator extends GeneratorForAnnotation<LeCoinsAnnotation> {
  @override
  Future<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {
    final knownCoins = _loadKnownCoins();

    final coinsClass = cb.Class((c) {
      c.name = "Coins";

      // get all method
      c.methods.add(cb.Method.returnsVoid((m) => m
        ..name = "all"
        ..static = true
        ..type = cb.MethodType.getter
        ..returns = cb.refer("Map<String, Coin>", 'package:le_crypto_alerts/support/utils.dart')
        ..body = cb.Code("return _getAll();")));

      // Get Coin
      c.methods.add(cb.Method.returnsVoid((m) => m
        ..name = "getCoin"
        ..static = true
        ..returns = cb.refer("Coin", 'package:le_crypto_alerts/support/utils.dart')
        ..requiredParameters.add(cb.Parameter((p) => p
          ..name = "value"
          ..type = cb.refer("dynamic")))
        // ..lambda = true
        ..body = cb.Code("return _getCoin(value);")));

      for (final coin in knownCoins) {
        final field = cb.FieldBuilder()
          ..name = "\$${coin.symbol}"
          ..docs.addAll(['// ignore: non_constant_identifier_names'])
          ..static = true
          ..modifier = cb.FieldModifier.constant
          ..assignment = cb.Code('const Coin.instance(name:"${coin.name}", symbol:"${coin.symbol}")');

        c.fields.add(field.build());
      }

      final allCoinsField = cb.FieldBuilder()
        ..name = "_coins"
        ..static = true
        ..modifier = cb.FieldModifier.constant
        ..assignment = cb.Code([
          "{",
          knownCoins.map((coin) => '"${coin.symbol}": \$${coin.symbol}').join(",\n"),
          "}",
        ].join("\n"));

      c.fields.add(allCoinsField.build());

      return c;
    });

    final emitter = cb.DartEmitter();
    var generated = ds.DartFormatter().format('${coinsClass.accept(emitter)}');

    //NOTE: a
    generated = generated.replaceAll("void getCoin", "Coin getCoin");
    generated = generated.replaceAll("void get all", "Map<String, Coin> get all");

    return generated;
  }
}

class LePairsGenerator extends GeneratorForAnnotation<LePairsAnnotation> {
  @override
  Future<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {
    // final knownCoins = _loadKnownCoins();
    final knownPairs = _loadKnownPairs();

    final pairsFields = [
      for (final pair in knownPairs)
        cb.Field((f) => f
          ..name = "\$${pair.base}_${pair.quote}"
          ..docs.addAll(['// ignore: non_constant_identifier_names'])
          ..static = true
          ..modifier = cb.FieldModifier.final$
          ..assignment = cb.Code('Pair.instance(base:Coin("${pair.base}"), quote:Coin("${pair.quote}"))'))
    ];

    final pairAliasesField = cb.Field((f) => f
      ..name = "_pairs"
      ..static = true
      ..modifier = cb.FieldModifier.final$
      ..assignment = cb.Code([
        "{",
        for (final pair in knownPairs) ...[
          '"${pair.base}${pair.quote}": \$${pair.base}_${pair.quote},',
          '"${pair.base}/${pair.quote}": \$${pair.base}_${pair.quote},',
        ],
        "}",
      ].join("\n")));

    final getAllMethod = cb.Method.returnsVoid((method) => method
      ..name = "getAll"
      ..static = true
      ..returns = cb.refer("List<Pair>", 'package:le_crypto_alerts/metas/pair.dart')
      ..body = cb.Code("return _getAll();"));

    final getPairMethod = cb.Method.returnsVoid((method) => method
      ..name = "getPair"
      ..requiredParameters.add(cb.Parameter((parm) => parm
        ..name = "value"
        ..type = cb.refer("dynamic")))
      ..static = true
      ..returns = cb.refer("Pair", 'package:le_crypto_alerts/metas/pair.dart')
      ..body = cb.Code("return _getPair(value);"));

    final getPair2Method = cb.Method.returnsVoid((method) => method
      ..name = "getPair2"
      ..requiredParameters.add(cb.Parameter((parm) => parm
        ..name = "base"
        ..type = cb.refer("dynamic")))
      ..requiredParameters.add(cb.Parameter((parm) => parm
        ..name = "quote"
        ..type = cb.refer("dynamic")))
      ..static = true
      ..returns = cb.refer("Pair", 'package:le_crypto_alerts/metas/pair.dart')
      ..body = cb.Code("return _getPair2(base, quote);"));

    final pairsClass = cb.Class((c) => c
      ..name = "Pairs"
      ..fields.addAll([
        ...pairsFields,
        pairAliasesField,
      ])
      ..methods.addAll([
        getAllMethod,
        getPairMethod,
        getPair2Method,
      ]));

    final emitter = cb.DartEmitter();
    var generated = ds.DartFormatter().format('${pairsClass.accept(emitter)}');

    generated = generated.replaceAll("void getAll", "List<Pair> getAll");
    generated = generated.replaceAll("void getPair", "Pair getPair");

    return generated;
  }
}

Builder leCoinsBuilder(BuilderOptions options) => PartBuilder([LeCoinsGenerator()], '.le.coins.dart');

Builder lePairsBuilder(BuilderOptions options) => PartBuilder([LePairsGenerator()], '.le.pairs.dart');
