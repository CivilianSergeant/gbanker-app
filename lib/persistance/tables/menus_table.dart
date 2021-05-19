import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class MenusTable implements IDatabaseDDL{

  String _tableName = "menus";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "menu_name VARCHAR(50),"
        "alias VARCHAR(50),"
        "groups VARCHAR(50),"
        "display_order INTEGER,"
        "is_active tinyint(1)"
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