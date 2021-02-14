import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Persistence {
  static const VERSION_1 = 1;

  static const VERSION_CURRENT = VERSION_1;

  static const WATCHING_TICKERS = "watching_tickers";

  static Persistence _instance;

  static Persistence get instance {
    if (_instance == null) {
      return _instance = Persistence();
    }
    return _instance;
  }

  Future<Database> open() async {
    // Avoid errors caused by flutter upgrade.
    WidgetsFlutterBinding.ensureInitialized();

    // Open the database and store the reference.
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'default.db'),

      onUpgrade: _onUpgrade,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: VERSION_CURRENT,
    );

    return database;
  }

  FutureOr<void> openx(FutureOr<void> Function(Database db) fun) async {
    var db = await open();
    try {
      var probablySomeFuture = fun(db);
      if (probablySomeFuture is Future) {
        await probablySomeFuture;
      }
    } catch (e) {
      print(e);
    }
    await db.close();
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    final commands = {
      1: (Batch batch) {
        batch.execute("CREATE TABLE coins(id VARCHAR(140) PRIMARY KEY, name VARCHAR(50), symbol VARCHAR(50))");
        batch.execute("CREATE TABLE pairs(id VARCHAR(140) PRIMARY KEY, base VARCHAR(50), quote VARCHAR(50))");
        batch.execute("CREATE TABLE watching_tickers(id VARCHAR(140) PRIMARY KEY, exchange VARCHAR(50), base VARCHAR(50), quote VARCHAR(50))");
        batch.execute("""
          CREATE TABLE accounts(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name VARCHAR(140), 
              type VARCHAR(50),
              extras TEXT
          )
        """);
      },
    };

    /// Filtrar os comandos para fazer o migration para a versão correta
    final updaters = commands.entries.where((element) => element.key > oldVersion && element.key <= newVersion).map((e) => e.value); //.fold<List<String>>(List<String>(), (previousValue, element) => previousValue..addAll(element.value));

    if (updaters.isEmpty) return null;

    final batch = db.batch();

    for (final updater in updaters) updater(batch);

    return batch.commit();
  }

  call(FutureOr<void> Function(Database db) fun) {
    return openx((db) async {
      final result = fun(db);
      if (result is Future) {
        await result;
      }
    });
  }
}
