import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class PurposesTable implements IDatabaseDDL{

  String _tableName = "purposes";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "purpose_code VARCHAR(5),"
        "purpose_name VARCHAR(50),"
        "org_id integer,"
        "is_active tinyint(1),"
        "is_active_date varchar(20),"
        "create_user varchar(35),"
        "create_date varchar(20),"
        "main_sector varchar(50),"
        "main_sector_name varchar(100),"
        "sub_sector varchar(50),"
        "sub_sector_name varchar(100),"
        "main_loan_sector varchar(10)"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_org_id ON "+_tableName+"(org_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

}