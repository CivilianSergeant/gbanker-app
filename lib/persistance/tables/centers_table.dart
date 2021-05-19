import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class CentersTable implements IDatabaseDDL{

  String _tableName = "centers";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "center_code VARCHAR(11),"
      "office_id INTEGER,"
      "center_name VARCHAR(200)"
      ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

  @override
  List<String> createIndexes() {
    // TODO: implement createIndexes
    return null;
  }


}
