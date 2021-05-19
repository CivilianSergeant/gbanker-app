import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class LoanCollectionsTable implements IDatabaseDDL{
  String _tableName = "loan_collections";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "office_id INTEGER,"
        "center_id INTEGER,"
        "product_id INTEGER,"
        "member_id INTEGER,"
        "amount REAL,"
        "recoverable REAL,"
        "loan_recovery REAL,"
        "summary_id INTEGER,"
        "trx_type INTEGER,"
        "token VARCHAR(200),"
        "installment_date VARCHAR(25),"
        "product_type INTEGER,"
        "loan_installment REAL,"
        "int_installment REAL,"
        "int_charge REAL,"
        "fine REAL,"
        "created_at VARCHAR(20),"
        "is_deleted TINYINT(1) DEFAULT 0"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_office_id ON "+_tableName+"(office_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_center_id ON "+_tableName+"(center_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_product_id ON "+_tableName+"(product_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_member_id ON "+_tableName+"(member_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_summary_id ON "+_tableName+"(summary_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_trx_type ON "+_tableName+"(trx_type);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_product_type ON "+_tableName+"(product_type);");
    return indexes;
  }

  @override
  String dropDDL() {

    return "DROP TABLE IF EXISTS " + _tableName;
  }

}