import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class LoanCollectionHistoryTable implements IDatabaseDDL {
  String _tableName = "loan_collection_histories";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "collection_id INTEGER,"
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
        "installment_date VARCHAR(30),"
        "product_type INTEGER,"
        "loan_installment REAL,"
        "int_installment REAL,"
        "int_charge REAL,"
        "fine REAL,"
        "created_at VARCHAR(20)"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_collection_id ON "+_tableName+"(collection_id);");
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