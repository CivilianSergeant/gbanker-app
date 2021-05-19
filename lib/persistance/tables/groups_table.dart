import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class GroupsTable implements IDatabaseDDL{

  String _tableName = "groups";

  String get tableName{
    return this._tableName;
  }
  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "group_code VARCHAR(11),"
      "office_id INTEGER"
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