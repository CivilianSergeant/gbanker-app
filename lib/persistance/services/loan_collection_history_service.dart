import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/loan_collection_history_table.dart';
import 'package:sqflite/sqflite.dart';

class LoanCollectionHistoryService {
  static Future<List<Map<String,dynamic>>>  getCollections({int centerId,String createdDate}) async{
    final Database db = await DbProvider.db.database;
    var tableName = LoanCollectionHistoryTable().tableName;
    var memberName = "(SELECT member_name from member_products WHERE product_id = lc.product_id AND member_id = lc.member_id) as member_name";
    var centerName = "(SELECT center_name from member_products WHERE product_id = lc.product_id AND center_id = lc.center_id) as center_name";
    var productName = "(SELECT product_name from member_products WHERE product_id = lc.product_id) as product_name";
    var sql = "SELECT ${productName},${memberName},${centerName},lc.center_id, lc.product_id,lc.member_id, recoverable, amount, (lc.recoverable-lc.amount) as due,installment_date,created_at FROM "+tableName+" as lc";

    if(centerId != null || createdDate != null) {
      sql += " WHERE ";
    }

    if(centerId != null){
      sql += "center_id="+centerId.toString();
      if(createdDate != null){
        sql+= " AND installment_date LIKE '"+createdDate+"%'";
      }
    }else{
      if(createdDate != null){
        sql+= " installment_date LIKE '"+createdDate+"%'";
      }
    }


    List<Map<String,dynamic>> collections = await db.rawQuery(sql);

    return collections;
  }
}