import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class MiscsTable implements IDatabaseDDL{


  String _tableName = "miscs";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "misc_id INTEGER,"
        "office_id INTEGER,"
        "center_id INTEGER,"
        "member_id INTEGER,"
        "product_id INTEGER,"
        "amount REAL,"
        "transaction_date VARCHAR(20),"
        "remarks VARCHAR(255)"
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