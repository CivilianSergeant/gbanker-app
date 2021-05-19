import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class MemberCategoriesTable implements IDatabaseDDL{
  String _tableName = "member_categories";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "category_code VARCHAR(11),"
      "category_name VARCHAR(100)"
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