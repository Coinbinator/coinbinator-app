import 'dart:async';
import 'dart:io';

import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
import 'package:le_crypto_alerts/database/converters/CoinConverter.dart';
import 'package:le_crypto_alerts/database/converters/DateTimeConverter%20.dart';
import 'package:le_crypto_alerts/database/daos/AppDao.dart';
import 'package:le_crypto_alerts/database/entities/AccountEntity.dart';
import 'package:le_crypto_alerts/database/entities/AlertEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerWatchEntity.dart';
import 'package:le_crypto_alerts/database/migrations/migration_1_to_2.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@TypeConverters([CoinConverter, DateTimeConverter])
@Database(
    version: 1,
    entities: [AccountEntity, AlertEntity, TickerEntity, TickerWatchEntity])
abstract class AppDatabase extends FloorDatabase {
  AppDao get appDao;

  static build() async {
    /// O Builder padrao tem um defeito e nao encontra o path do linux
    final databasePath = await Future<String>(() async {
      //NOTE: for testes
      //if (null == null) return null;
      // if (Platform.isAndroid)

      return join(
          await sqfliteDatabaseFactory.getDatabasesPath(), 'default_1.db');
    });

    debugPrint("database: $databasePath");

    /// Replicating the processon on ```$FloorAppDatabase.databaseBuilder```
    /// because it is incompatible with the linux ( and possible all desktops platforms )
    final database = _$AppDatabase();
    database.database = await database.open(
      databasePath,
      [
        migration_1_to_2,
      ],
      null,
    );

    return database;
  }
}
