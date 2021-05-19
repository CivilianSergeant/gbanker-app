import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class SubDistrictsTable implements IDatabaseDDL{
  String _tableName = "sub_districts";
  String get tableName{
    return this._tableName;
  }
  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "district_id INTEGER,"
      "sub_district_code VARCHAR(11),"
      "sub_district_name VARCHAR(100)"
      ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS "+_tableName;
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_district_id ON "+_tableName+"(district_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_sub_district_code ON "+_tableName+"(sub_district_code);");
    return indexes;
  }

}