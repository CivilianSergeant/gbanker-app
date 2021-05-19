import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class MenuPermissionsTable implements IDatabaseDDL{

  String _tableName = "menu_permissions";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "role_id VARCHARVARCHAR(5),"
        "alias VARCHAR(50),"
        "is_active tinyint(1),"
        "view_permission tinyint(1),"
        "create_permission tinyint(1),"
        "delete_permission tinyint(1),"
        "approve_permission tinyint(1),"
        "disburse_permission tinyint(1)"
        ")";
  }

  @override
  List<String> createIndexes() {
    // TODO: implement createIndexes
    return null;
  }

  @override
  String dropDDL() {

    return "DROP TABLE IF EXISTS " + _tableName;;
  }


}