import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class MemberAddressTable implements IDatabaseDDL{
  String _tableName="member_addresses";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "member_id INTEGER NOT NULL,"
      "country_id INTEGER,"
      "division_id INTEGER,"
      "district_id INTEGER,"
      "sub_district_id INTEGER,"
      "union_id INTEGER,"
      "village_id INETGER,"
      "zip_code VARCHAR(100),"
      "per_country_id INTEGER,"
      "per_division_id INTEGER,"
      "per_district_id INTEGER,"
      "per_sub_district_id INTEGER,"
      "per_union_id INTEGER,"
      "per_village_id INETGER,"
      "per_zip_code VARCHAR(100),"
      "permanent_address VARCHAR(500),"
      "present_address VARCHAR(500)"
      ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS "+_tableName;
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_member_id ON "+_tableName+"(member_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_country_id ON "+_tableName+"(country_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_division_id ON "+_tableName+"(division_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_district_id ON "+_tableName+"(district_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_sub_district_id ON "+_tableName+"(sub_district_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_union_id ON "+_tableName+"(union_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_village_id ON "+_tableName+"(village_id);");
    return indexes;
  }

}