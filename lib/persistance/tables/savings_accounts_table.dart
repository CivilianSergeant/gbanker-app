import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class SavingsAccountsTable implements IDatabaseDDL{

  String _tableName = "savings_accounts";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "center_id INTEGER,"
        "member_id INTEGER,"
        "product_id INTEGER,"
        "savings_installment REAL,"
        "is_posted_to_ledger TINYINT(1) DEFAULT 0"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_center_id ON "+_tableName+"(center_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_member_id ON "+_tableName+"(member_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_product_id ON "+_tableName+"(product_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

}