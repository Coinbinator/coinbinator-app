// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_persistence.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AppDao _appDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `accounts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `type` TEXT, `extras` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tickers` (`id` TEXT, `exchange` TEXT, `base` TEXT, `quote` TEXT, `updatedAt` INTEGER, `price` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ticker_watches` (`id` TEXT, `exchange` TEXT, `base` TEXT, `quote` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AppDao get appDao {
    return _appDaoInstance ??= _$AppDao(database, changeListener);
  }
}

class _$AppDao extends AppDao {
  _$AppDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tickerEntityInsertionAdapter = InsertionAdapter(
            database,
            'tickers',
            (TickerEntity item) => <String, dynamic>{
                  'id': item.id,
                  'exchange': item.exchange,
                  'base': item.base,
                  'quote': item.quote,
                  'updatedAt': item.updatedAt,
                  'price': item.price
                }),
        _tickerWatchEntityInsertionAdapter = InsertionAdapter(
            database,
            'ticker_watches',
            (TickerWatchEntity item) => <String, dynamic>{
                  'id': item.id,
                  'exchange': item.exchange,
                  'base': item.base,
                  'quote': item.quote
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TickerEntity> _tickerEntityInsertionAdapter;

  final InsertionAdapter<TickerWatchEntity> _tickerWatchEntityInsertionAdapter;

  @override
  Future<List<TickerEntity>> findTickers() async {
    return _queryAdapter.queryList('SELECT * FROM tickers',
        mapper: (Map<String, dynamic> row) => TickerEntity(
            row['id'] as String,
            row['exchange'] as String,
            row['base'] as String,
            row['quote'] as String,
            row['updatedAt'] as int,
            row['price'] as double));
  }

  @override
  Future<TickerEntity> findTickerById(String id) async {
    return _queryAdapter.query('SELECT * FROM tickers WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => TickerEntity(
            row['id'] as String,
            row['exchange'] as String,
            row['base'] as String,
            row['quote'] as String,
            row['updatedAt'] as int,
            row['price'] as double));
  }

  @override
  Future<List<TickerWatchEntity>> findTickerWatches() async {
    return _queryAdapter.queryList('SELECT * FROM ticker_watches',
        mapper: (Map<String, dynamic> row) => TickerWatchEntity(
            row['id'] as String,
            row['exchange'] as String,
            row['base'] as String,
            row['quote'] as String));
  }

  @override
  Future<TickerWatchEntity> findTickerWatchById(String id) async {
    return _queryAdapter.query('SELECT * FROM ticker_watches WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => TickerWatchEntity(
            row['id'] as String,
            row['exchange'] as String,
            row['base'] as String,
            row['quote'] as String));
  }

  @override
  Future<int> insertTicker(TickerEntity ticker) {
    return _tickerEntityInsertionAdapter.insertAndReturnId(
        ticker, OnConflictStrategy.abort);
  }

  @override
  Future<int> insertTickerWatch(TickerWatchEntity ticker) {
    return _tickerWatchEntityInsertionAdapter.insertAndReturnId(
        ticker, OnConflictStrategy.abort);
  }
}
