import 'package:floor/floor.dart';

@deprecated
abstract class MetaEntityIds {
  static const int ACTIVE_ALERTS = 0;
}

@deprecated
@Entity(tableName: 'metas')
class MetaEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String value;

  MetaEntity(this.id, this.value);
}
