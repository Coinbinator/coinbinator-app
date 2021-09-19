import 'dart:async';

import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/database/converters/CoinConverter.dart';
import 'package:le_crypto_alerts/database/daos/AppDao.dart';
import 'package:le_crypto_alerts/database/entities/AccountEntity.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerWatchEntity.dart';
import 'package:le_crypto_alerts/database/migrations/migration_1_to_2.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@TypeConverters([CoinConverter])
@Database(
    version: 1,
    entities: [AccountEntity, AlertEntity, TickerEntity, TickerWatchEntity])
abstract class AppDatabase extends FloorDatabase {
  AppDao get appDao;

  static build() async {
    /// O Builder padrao tem um defeito e nao encontra o path do linux
    final databasePath = false == null
        ? null
        : join(await sqfliteDatabaseFactory.getDatabasesPath(), 'default_0.db');
    print("database path: $databasePath");

    final database = await $FloorAppDatabase
        .databaseBuilder(databasePath)
        .addMigrations([
          migration_1_to_2,
        ])
        .addCallback(null)
        .build();

    // final database = _$AppDatabase();

    // database.database = await database.open(
    //   databasePath,
    //   [
    //     migration_1_to_2,
    //   ],
    //   null,
    // );

    return database;
  }
}
