import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class GroupTypeTable implements IDatabaseDDL{
  String _tableName = "group_types";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "text VARCHAR(11),"
        "value VARCHAR(11),"
        "selected TINYINT(1)"
        ")";
  }

  @override
  List<String> createIndexes() {
    // TODO: implement createIndexes
    return null;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

}