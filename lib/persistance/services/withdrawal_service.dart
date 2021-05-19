import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/LoanCollection.dart';
import 'package:gbanker/persistance/entities/Withdrawal.dart';
import 'package:gbanker/persistance/tables/loan_collections_table.dart';
import 'package:gbanker/persistance/tables/member_products_table.dart';
import 'package:gbanker/persistance/tables/withdraw_table.dart';
import 'package:sqflite/sqflite.dart';

class WithdrawalService{

  static Future<int> addWithdrawal(Withdrawal withdrawal) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(WithdrawalsTable().tableName, withdrawal.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateWithdrawals() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+WithdrawalsTable().tableName);
    return;
  }

  static Future<int> deleteWithdrawal({int memberId, String idIn}) async {
    final Database db = await DbProvider.db.database;
    int i=0;
    if(memberId!=null) {
      await db.execute("DELETE FROM " + WithdrawalsTable().tableName +
          " WHERE member_id=" + memberId.toString());
      i=1;
    }

    if(idIn != null){
      await db.execute("DELETE FROM " + WithdrawalsTable().tableName +
          " WHERE member_id IN (" + idIn.toString()+")");
      i=1;
    }
    return i;
  }

  static Future<bool> hasWithdrawal() async {
    final Database db = await DbProvider.db.database;
    String sql="SELECT COUNT(*) as totalWithdrawal FROM "+WithdrawalsTable().tableName;
    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    bool _hasCollection = false;
    maps.forEach((Map<String,dynamic> map){
      if(map['totalWithdrawal']>0){
        _hasCollection = true;
      }
    });

    return _hasCollection;
  }

  static Future<int> getCollectionCount() async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> collection = await db.rawQuery("SELECT COUNT(*) as member_collected FROM(SELECT COUNT(*) FROM ${LoanCollectionsTable().tableName} GROUP BY member_id)");
    int memberCollected = 0;
    collection.forEach((Map<String,dynamic> c){

      memberCollected = (c['member_collected'] != null)? c['member_collected'] : 0;
    });

    return memberCollected;
  }

  static Future<double> getCollectionAmount() async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> collection = await db.rawQuery("SELECT sum(amount) total FROM ${LoanCollectionsTable().tableName}");
    double totalAmountCollected = 0;
    collection.forEach((Map<String,dynamic> c){
      totalAmountCollected = (c['total'] != null)? c['total'] : 0;
    });

    return totalAmountCollected;
  }

  static Future<List<Map<String,dynamic>>> getMemberWiseWithdrawalList({int centerId}) async {
    final Database db = await DbProvider.db.database;
    var tableName = WithdrawalsTable().tableName;
    var loanSql = "(Select sum(amount) from ${tableName} WHERE product_type=1 AND member_id=lc.member_id GROUP BY member_id) as loan";
    var savingsSql = "(Select sum(amount) from ${tableName} WHERE product_type=0 AND member_id=lc.member_id GROUP BY member_id) as savings";
    var totalSql = "(Select sum(due_amount-amount) from ${tableName} WHERE member_id=lc.member_id GROUP BY member_id) as total";

    var sql = "SELECT lc.member_id, mp.member_name,"+loanSql+","+savingsSql+","+totalSql+"  FROM ${tableName} as lc "
       +" JOIN member_products as mp"+
        " ON mp.member_id = lc.member_id"+
        ((centerId != null)? " WHERE lc.center_id="+centerId.toString() :"")
        +" GROUP BY lc.member_id";
    List<Map<String,dynamic>> collections = await db.rawQuery(sql);

    return collections;
  }

  static Future<List<Map<String,dynamic>>> getWithdrawals({bool isDeletedOnly}) async{
    final Database db = await DbProvider.db.database;
    var tableName = WithdrawalsTable().tableName;
    var memberName = "(SELECT member_name from member_products WHERE product_id = w.product_id AND member_id = w.member_id) as member_name";
    var centerName = "(SELECT center_name from member_products WHERE product_id = w.product_id AND center_id = w.center_id) as center_name";
    var productName = "(SELECT product_name from member_products WHERE product_id = w.product_id) as product_name";
    var sql = "SELECT ${productName},${memberName},${centerName},w.center_id, w.product_id,w.member_id, due_amount, amount FROM "+tableName+" as w";


    if(isDeletedOnly != null) {
      if (isDeletedOnly) {
        sql += " WHERE is_deleted=1";
      } else {
        sql += " WHERE is_deleted=0";
      }
    }


    List<Map<String,dynamic>> collections = await db.rawQuery(sql);
    return collections;
  }

  static Future<int> softDeleteWithdrawal({int memberId, String idIn}) async {
    final Database db = await DbProvider.db.database;
    int i=0;
    if(memberId!=null) {
      await db.execute("UPDATE " + WithdrawalsTable().tableName +
          " SET is_deleted=1 WHERE member_id=" + memberId.toString());
      i=1;
    }

    if(idIn != null){
      await db.execute("UPDATE " + WithdrawalsTable().tableName +
          " SET is_deleted=1 WHERE member_id IN (" + idIn.toString()+")");
      i=1;
    }

    if(memberId == null && idIn == null){
      await db.execute("UPDATE " + WithdrawalsTable().tableName +
          " SET is_deleted=1");
      i=1;
    }
    return i;
  }
}