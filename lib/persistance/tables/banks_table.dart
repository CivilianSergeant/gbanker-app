import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class BanksTable implements IDatabaseDDL{


  String _tableName = "banks";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "bank_code VARCHAR(11),"
        "bank_name VARCHAR(150)"
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