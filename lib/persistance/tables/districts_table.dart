import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class DistrictsTable implements IDatabaseDDL{
  String _tableName = "districts";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "division_id INTEGER,"
      "district_code VARCHAR(11),"
      "district_name VARCHAR(100)"
      ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_division_id ON "+_tableName+"(division_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_district_code ON "+_tableName+"(district_code);");
    return indexes;
  }


}