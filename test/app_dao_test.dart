import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/database/entities/TickerEntity.dart';
import 'package:le_crypto_alerts/database/floor_persistence.dart';

void main() {
  testWidgets('tests floor app dao', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      print(database);

      final b = await database.appDao.findTickers();
      print(b);

      final i = await database.appDao.insertTicker(TickerEntity(DateTime.now().toString(), "b", "q"));
      print(i);

      final c = await database.appDao.findTickers();
      print(c);
    });
  });
}
