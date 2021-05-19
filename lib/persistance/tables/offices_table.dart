import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class OfficesTable implements IDatabaseDDL{
  String _tableName = "offices";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "office_id INTEGER,"
      "office_code VARCHAR(11),"
      "office_name VARCHAR(50)"
      ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS "+_tableName;
  }

  @override
  List<String> createIndexes() {
    // TODO: implement createIndexes
    return null;
  }

}