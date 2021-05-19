import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class MembersTable implements IDatabaseDDL{
  String _tableName = "members";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {
    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "center_id INTEGER NOT NULL,"
        "group_id INTEGER,"
        "member_code VARCHAR(30),"
        "member_id VARCHAR(30),"
        "member_pass_book_register_id INTEGER,"
        "member_pass_book_no INTEGER DEFAULT 0,"
        "member_category_id INTEGER NOT NULL,"
        "first_name VARCHAR(300),"
        "middle_name VARCHAR(100),"
        "last_name VARCHAR(100),"
        "date_of_birth VARCHAR(10),"
        "age VARCHAR(150),"
        "birth_place_id INTEGER,"
        "citizenship_id VARCHAR(10),"
        "gender VARCHAR(10),"
        "nid VARCHAR(30),"
        "smart_card_no VARCHAR(30),"
        "admission_date VARCHAR(10),"
        "home_type VARCHAR(10),"
        "group_type VARCHAR(10),"
        "education_id INTEGER,"
        "identity_type_id INTEGER,"
        "issue_date VARCHAR(30),"
        "other_id_no VARCHAR(30),"
        "expire_date VARCHAR(30),"
        "provider_country_id INTEGER,"
        "father_name VARCHAR(300),"
        "mother_name VARCHAR(300),"
        "family_member INTEGER,"
        "email VARCHAR(300),"
        "contact_no VARCHAR(50),"
        "family_contact_no VARCHAR(50),"
        "reference_name VARCHAR(150),"
        "spouse_name VARCHAR(300),"
        "co_applicant_name VARCHAR(300),"
        "economic_activity_id INTEGER,"
        "total_wealth VARCHAR(100),"
        "marital_status VARCHAR(100),"
        "member_status VARCHAR(5) DEFAULT 0,"
        "member_type_id VARCHAR(100),"
        "tin VARCHAR(40),"
        "tax_amount REAL,"
        "is_any_fs TINYINT(1),"
        "f_service_name VARCHAR(140),"
        "fin_service_choice_id INTEGER,"
        "transaction_choice_id INTEGER,"
        "img_path VARCHAR(500),"
        "img_sync TINYINT DEFAULT 0,"
        "sig_img_path VARCHAR(500),"
        "sig_img_sync TINYINT DEFAULT 0,"
        "org_id integer,"
        "office_id integer,"
        "created_user varchar(20),"
        "created_date varchar(30)"
        ")";
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS "+_tableName;
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_center_id ON "+_tableName+"(center_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_group_id ON "+_tableName+"(group_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_birth_place_id ON "+_tableName+"(birth_place_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_citizenship_id ON "+_tableName+"(citizenship_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_home_type ON "+_tableName+"(home_type);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_group_type ON "+_tableName+"(group_type);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_education_id ON "+_tableName+"(education_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_economic_activity_id ON "+_tableName+"(economic_activity_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_marital_status ON "+_tableName+"(marital_status);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_member_type_id ON "+_tableName+"(member_type_id);");
    return indexes;
  }

}
