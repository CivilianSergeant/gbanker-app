import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class GuarantorsTable implements IDatabaseDDL{

  String _tableName = "guarantors";

  String get tableName{
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "loan_proposal_id INTEGER,"
        "member_id INTEGER,"
        "name VARCHAR(100),"
        "father VARCHAR(150),"
        "relation VARCHAR(100),"
        "date_of_birth VARCHAR(30),"
        "age VARCHAR(30),"
        "address VARCHAR(300)"
        ")";
  }

  @override
  List<String> createIndexes() {
    List<String> indexes = List<String>();
    indexes.add("CREATE INDEX idx_"+_tableName+"_loan_propsal_id ON "+_tableName+"(loan_proposal_id);");
    return indexes;
  }

  @override
  String dropDDL() {
    return "DROP TABLE IF EXISTS " + _tableName;
  }

}