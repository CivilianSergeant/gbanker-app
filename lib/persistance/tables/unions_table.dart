import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class UnionsTable implements IDatabaseDDL{
  String _tableName = "unions";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "sub_district_code VARCHAR(11),"
      "union_code VARCHAR(11),"
      "union_name VARCHAR(100)"
      ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS "+_tableName;
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_sub_district_code ON "+_tableName+"(sub_district_code);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_union_code ON "+_tableName+"(union_code);");
    return indexes;
  }

}