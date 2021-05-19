import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class DivisionsTable implements IDatabaseDDL{
  String _tableName = "divisions";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "country_id INTEGER NOT NULL,"
      "division_code VARCHAR(11),"
      "division_name VARCHAR(50)"
      ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_country_id ON "+_tableName+"(country_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_division_code ON "+_tableName+"(division_code);");
    return indexes;
  }

}