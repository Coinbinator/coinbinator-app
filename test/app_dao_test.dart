import 'package:flutter_test/flutter_test.dart';
import 'package:le_crypto_alerts/database/persistence.dart';

void main() {
  testWidgets('tests floor app dao', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      print(database);
    });
  });
}
