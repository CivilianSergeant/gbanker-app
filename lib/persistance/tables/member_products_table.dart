import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class MemberProductsTable implements IDatabaseDDL{
  String _tableName = "member_products";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "office_id INTEGER,"
        "office_code VARCHAR(100),"
        "office_name VARCHAR(150),"
        "center_id INTEGER,"
        "center_code VARCHAR(100),"
        "center_name VARCHAR(150),"
        "member_id INTEGER,"
        "member_code VARCHAR(100),"
        "member_name VARCHAR(200),"
        "product_id INTEGER,"
        "product_code VARCHAR(100),"
        "product_name VARCHAR(150),"
        "product_type TINYINT(1),"
        "loan_recovery REAL,"
        "recoverable REAL,"
        "balance REAL,"
        "installment_date VARCHAR(20),"
        "installment_no INTEGER,"
        "trx_type TINYINT(1),"
        "summary_id INTEGER,"
        "prin_balance REAL,"
        "ser_balance REAL,"
        "interest_calculation_method VARCHAR(5),"
        "duration INTEGER,"
        "duration_over_loan_due REAL,"
        "duration_over_int_due REAL,"
        "loan_due REAL,"
        "int_due REAL,"
        "cum_int_charge REAL,"
        "cum_interest_paid REAL,"
        "principal_loan REAL,"
        "loan_repaid REAL,"
        "int_charge REAL,"
        "new_due REAL,"
        "main_product_code VARCHAR(100),"
        "doc INTEGER,"
        "account_no VARCHAR(100),"
        "fine REAL,"
        "sc_paid REAL,"
        "personal_withdraw REAL,"
        "personal_saving REAL,"
        "cum_loan_due REAL,"
        "cum_int_due REAL,"
        "org_id INTEGER,"
        "disburse_date VARCHAR(30),"
        "disburse_amount REAL,"
        "allow_fine INTEGER"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_office_id ON "+_tableName+"(office_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_center_id ON "+_tableName+"(center_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_member_id ON "+_tableName+"(member_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_product_id ON "+_tableName+"(product_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_summary_id ON "+_tableName+"(summary_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_trx_type ON "+_tableName+"(trx_type);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_product_type ON "+_tableName+"(product_type);");
    return indexes;
  }

  @override
  String dropDDL() {

    return "DROP TABLE IF EXISTS "+_tableName;
  }

}