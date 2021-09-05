import 'package:floor/floor.dart';

@Entity(tableName: 'accounts')
class AccountEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String name;

  final String type;

  final String extras;

  AccountEntity(this.id, this.name, this.type, this.extras);
}
