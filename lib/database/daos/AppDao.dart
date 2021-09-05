import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/database/entities/TickerEntity.dart';
import 'package:le_crypto_alerts/database/entities/TickerWatchEntity.dart';

@dao
abstract class AppDao {
  /* TickerEntity  */

  @Query("SELECT * FROM tickers ")
  Future<List<TickerEntity>> findTickers();

  @Query("SELECT * FROM tickers WHERE id = :id")
  Future<TickerEntity> findTickerById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertTicker(TickerEntity ticker);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertTickers(List<TickerEntity> tickers);

  @update
  Future<int> updateTicker(TickerEntity ticker);

  /* TickerWatchEntity  */

  @Query("SELECT * FROM ticker_watches ")
  Future<List<TickerWatchEntity>> findAllTickerWatches();

  @Query("SELECT * FROM ticker_watches WHERE id = :id")
  Future<TickerWatchEntity> findTickerWatchById(String id);

  @insert
  Future<int> insertTickerWatch(TickerWatchEntity ticker);

  @delete
  Future<int> deleteTickerWatch(TickerWatchEntity ticker);
}
