import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqlite_def;
import 'package:sqflite_common/sqlite_api.dart' as common;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqlit_ffi;

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

  Future<common.Database> open() async {
    // Avoid errors caused by flutter upgrade.
    WidgetsFlutterBinding.ensureInitialized();

    final databaseFactory = value<common.DatabaseFactory>(() {
      if (Platform.isLinux) {
        sqlit_ffi.sqfliteFfiInit();
        return sqlit_ffi.databaseFactoryFfi;
      }
      return sqlite_def.databaseFactory;
    });

    final databasePath = join(await databaseFactory.getDatabasesPath(), 'default.db');

    // Open the database and store the reference.
    final Future<common.Database> database = databaseFactory.openDatabase(
      databasePath,
      options: common.OpenDatabaseOptions(onUpgrade: _onUpgrade, version: VERSION_CURRENT),
    );

    return database;
  }

  FutureOr<void> openx(FutureOr<void> Function(common.Database db) fun) async {
    final db = await open();
    try {
      final probablySomeFuture = fun(db);
      if (probablySomeFuture is Future) await probablySomeFuture;
    } catch (e) {
      print(e);
    }
    await db.close();
  }

  FutureOr<void> _onUpgrade(common.Database db, int oldVersion, int newVersion) {
    final commands = {
      1: (common.Batch batch) {
        batch.execute("CREATE TABLE coins(id VARCHAR(140) PRIMARY KEY, name VARCHAR(50), symbol VARCHAR(50))");
        batch.execute("CREATE TABLE pairs(id VARCHAR(140) PRIMARY KEY, base VARCHAR(50), quote VARCHAR(50))");
        batch.execute("CREATE TABLE ticker(id VARCHAR(140) PRIMARY KEY, exchange VARCHAR(50), base VARCHAR(50), quote VARCHAR(50)), updated_at INT, price REAL");
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

  call(FutureOr<void> Function(common.Database db) fun) {
    return openx((db) async {
      final result = fun(db);
      if (result is Future) {
        await result;
      }
    });
  }
}
