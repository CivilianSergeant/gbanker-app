import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class ProductsTable implements IDatabaseDDL{

  String _tableName = "products";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "product_id INTEGER,"
        "product_code VARCHAR(50),"
        "product_name VARCHAR(100),"
        "product_type INTEGER,"
        "interest_rate REAL,"
        "duration INTEGER,"
        "main_product_code VARCHAR(50),"
        "loan_installment REAL,"
        "interest_installment REAL,"
        "savings_installment REAL,"
        "min_limit REAL,"
        "max_limit REAL,"
        "interest_calculation_method VARCHAR(1),"
        "payment_frequency VARCHAR(1),"
        "main_item_name VARCHAR(100),"
        "grace_period INTEGER,"
        "sub_main_category VARCHAR(100),"
        "is_disbursement TINYINT(1),"
        "is_active TINYINT(1)"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_product_id ON "+_tableName+"(product_id);");
    return indexes;
  }

  @override
  String dropDDL() {

    return "DROP TABLE IF EXISTS " + _tableName;
  }

}