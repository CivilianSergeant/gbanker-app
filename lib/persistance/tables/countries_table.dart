import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class CountriesTable implements IDatabaseDDL{

  String _tableName = "countries";
  String get tableName {
    return this._tableName;
  }
  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "country_code VARCHAR(11),"
      "country_name VARCHAR(150),"
      "country_short_code VARCHAR(20),"
      "iso_code_3 VARCHAR(20),"
      "status TINYINT(1)"
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