import 'package:floor/floor.dart';
import 'package:le_crypto_alerts/database/entities/alert_entity.dart';
import 'package:le_crypto_alerts/database/entities/ticker_entity.dart';
import 'package:le_crypto_alerts/database/entities/ticker_watch_entity.dart';

@dao
abstract class AppDao {
  @Query("SELECT * FROM tickers")
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

  @Query("SELECT * FROM ticker_watches")
  Future<List<TickerWatchEntity>> findAllTickerWatches();

  @Query("SELECT * FROM ticker_watches WHERE id = :id")
  Future<TickerWatchEntity> findTickerWatchById(String id);

  @insert
  Future<int> insertTickerWatch(TickerWatchEntity ticker);

  @delete
  Future<int> deleteTickerWatch(TickerWatchEntity ticker);

  /* ALERTS */

  @Query("SELECT * FROM alerts")
  Future<List<AlertEntity>> findAllAlerts();

  @Query("SELECT * FROM alerts")
  Stream<List<AlertEntity>> findAllAlertsAsStream();

  @Query('SELECT * FROM alerts WHERE triggerState=${AlertEntityState.STATE_ACTIVE}')
  Stream<List<AlertEntity>> findActiveAlertsAsStream();

  @insert
  Future<int> insertAlert(AlertEntity alert);

  @update
  Future<int> updateAlert(AlertEntity alert);

  @delete
  Future<int> deleteAlert(AlertEntity alert);

  @transaction
  Future<void> updateAlerts(Iterable<AlertEntity> alerts) async {
    for (final alert in alerts) await updateAlert(alert);
  }
}
