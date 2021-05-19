import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class LoanProposalsTable implements IDatabaseDDL {

  String _tableName = "loan_proposals";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "proposal_no VARCHAR(100),"
        "loan_summary_id INTEGER,"
        "center_id INTEGER,"
        "office_id INTEGER,"
        "member_id INTEGER,"
        "member_name VARCHAR(200),"
        "member_code VARCHAR(50),"
        "center_code VARCHAR(50),"
        "center_name VARCHAR(100),"
        "frequency_mode VARCHAR(1),"
        "main_product_code VARCHAR(10),"
        "sub_main_product_code VARCHAR(150),"
        "product_id INTEGER,"
        "investor_id INTEGER,"
        "loan_term VARCHAR(1000),"
        "purpose_id VARCHAR(1000),"
        "disbursement_type_id INTEGER,"
        "applied_amount REAL,"
        "approved_amount REAL,"
        "duration INTEGER,"
        "co_applicant_name VARCHAR(200),"
        "member_pass_book_no INTEGER,"
        "loan_installment REAL,"
        "sc_installment REAL,"
        "trans_type_id INTEGER,"
        "guarantor_name VARCHAR(200),"
        "guarantor_father VARCHAR(200),"
        "guarantor_relation VARCHAR(200),"
        "date_of_birth VARCHAR(40),"
        "age VARCHAR(100),"
        "address VARCHAR(300),"
        "security_bank_name VARCHAR(200),"
        "security_branch_name VARCHAR(200),"
        "security_cheque_no VARCHAR(100),"
        "is_approved tinyint(1) DEFAULT 0,"
        "is_disbursed tinyint(1) DEFAULT 0,"
        "disburse_date VARCHAR(20),"
        "installment_start_date VARCHAR(20),"
        "bank_name VARCHAR(200),"
        "cheque_no VARCHAR(20),"
        "cheque_issue_date VARCHAR(20),"
        "approve_date VARCHAR(20),"
        "int_charge REAL,"
        "interest_rate REAL,"
        "product_installment_method_id INTEGER,"
        "product_installment_method_name VARCHAR(100),"
        "pi_loan_installment REAL,"
        "pi_int_installment REAL"
        ")";


  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_center_id ON "+_tableName+"(center_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_member_id ON "+_tableName+"(member_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_investor_id ON "+_tableName+"(investor_id);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_frequency_mode ON "+_tableName+"(frequency_mode);");
    indexes.add("CREATE INDEX idx_"+_tableName+"_loan_summary_id ON "+_tableName+"(loan_summary_id)");
    return indexes;
  }

  @override
  String dropDDL() {

    return "DROP TABLE IF EXISTS " + _tableName;
  }

}