import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class UsersTable implements IDatabaseDDL{
  String _tableName = "users";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "username VARCHAR(11),"
        "firstname VARCHAR(100),"
        "password VARCHAR(40),"
        "guid VARCHAR(150),"
        "orgId INTEGER,"
        "officeId INTEGER,"
        "officeName VARCHAR(300)"
        ")";
  }

  @override
  List<String> createIndexes() {
    // TODO: implement createIndexes
    return null;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS "+_tableName;
  }

}