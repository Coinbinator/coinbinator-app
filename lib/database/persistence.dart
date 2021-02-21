import 'dart:async';

import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/database/daos/AppDao.dart';
import 'package:le_crypto_alerts/database/entities/AccountEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerWatchEntity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'persistence.g.dart';

@Database(version: 1, entities: [AccountEntity, TickerEntity, TickerWatchEntity])
abstract class AppDatabase extends FloorDatabase {
  AppDao get appDao;

  static build() async {
    /// O Builder padrao tem um defeito e nao encontra o path do linux
    final databasePath = join(await sqfliteDatabaseFactory.getDatabasesPath(), 'default.db');

    final database = _$AppDatabase();

    database.database = await database.open(
      databasePath,
      [],
      null,
    );
    return database;
  }
}
