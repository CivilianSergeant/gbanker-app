import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class GendersTable implements IDatabaseDDL{
  String _tableName = "genders";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "text VARCHAR(11),"
        "value INTEGER,"
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