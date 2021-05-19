import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class BirthPlacesTable implements IDatabaseDDL{
  String _tableName = "birth_places";

  String get tableName{
    return this._tableName;
  }
  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "division_code VARCHAR(11),"
      "district_code VARCHAR(11),"
      "district_name VARCHAR(11)"
      ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_division_code ON "+_tableName+"(division_code);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_district_code ON "+_tableName+"(district_code);");
    return indexes;
  }


}