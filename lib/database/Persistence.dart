import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Persistence {
  static const VERSION_1 = 1;

  static const VERSION_CURRENT = VERSION_1;

  static const WHATCHING_TICKERS = "watching_tickers";

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
    var commands = {
      1: [
        //
        "CREATE TABLE coins(id VARCHAR(140) PRIMARY KEY, name VARCHAR(50), symbol VARCHAR(50))",
        "CREATE TABLE pairs(id VARCHAR(140) PRIMARY KEY, base VARCHAR(50), quote VARCHAR(50))",
        "CREATE TABLE watching_tickers(id VARCHAR(140) PRIMARY KEY, exchange VARCHAR(50), base VARCHAR(50), quote VARCHAR(50))",
      ],
    }
        // Filtrar os comandos para fazer o migration para a versão correta
        .entries
        .where((element) => element.key > oldVersion && element.key <= newVersion)
        .map((e) => e.value.join(";\n"))
        .join(";\n");

    return db.execute(commands);
  }
}
