import 'dart:async';

import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/database/daos/AppDao.dart';
import 'package:le_crypto_alerts/database/entities/AccountEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerWatchEntity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'floor_persistence.g.dart';

@Database(version: 1, entities: [AccountEntity, TickerEntity, TickerWatchEntity])
abstract class AppDatabase extends FloorDatabase {
  AppDao get appDao;
}
