import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/SavingsAccount.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/tables/savings_accounts_table.dart';
import 'package:sqflite/sqflite.dart';

class SavingsAccountService {

  static const SAVING_ACCOUNT_APPROVE = "api/saving-accounts/approve";

  static Future<void> truncateSavingAccounts() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+SavingsAccountsTable().tableName);
  }

  static Future<int> addSavingAccount(SavingsAccount sa) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(SavingsAccountsTable().tableName, sa.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<List<Map<String,dynamic>>> getSavingsAccounts() async {
    final Database db = await DbProvider.db.database;
    String productSql = "(SELECT p.product_name FROM products p WHERE p.product_id = sacc.product_id) as product_name";
    String productCodeSql = "(SELECT p1.product_code FROM products p1 WHERE p1.product_id = sacc.product_id) as product_code";
    String centerSql = "(SELECT c.center_name FROM centers c WHERE c.id = sacc.center_id) as center_name";
    String centerCodeSql = "(SELECT c1.center_code FROM centers c1 WHERE c1.id = sacc.center_id) as center_code";

    String memberSql = "(SELECT mp1.member_name AS member_name FROM member_products mp1 WHERE mp1.member_id=sacc.member_id GROUP BY member_code) as member_name";
    String memberCodeSql = "(SELECT mp2.member_code AS member_code FROM member_products mp2 WHERE mp2.member_id=sacc.member_id GROUP BY member_code) as member_code";
    String sql="SELECT sacc.id,members.member_id as mid,members.office_id,members.created_user,sacc.center_id, sacc.member_id, sacc.product_id, "+productSql+","+productCodeSql+","+
        centerSql+","+centerCodeSql+","+memberSql+","+memberCodeSql+", is_posted_to_ledger, savings_installment"
        " FROM "+SavingsAccountsTable().tableName+" AS sacc LEFT JOIN members on members.member_id = sacc.member_id";


    List<Map<String,dynamic>> maps = await db.rawQuery(sql);

    return maps;
  }

  static Future<int> deleteById(id) async{
    final Database db = await DbProvider.db.database;
    int deleted = await db.delete(SavingsAccountsTable().tableName,where: "id=?",whereArgs: [id]);
    return deleted;
  }

  static Future<bool> postToLedger(Map<String, dynamic> obj) async{
    //print(obj);
    bool netStatus = await NetworkService.check();
    Setting setting = await SettingService.getSetting("orgUrl");
    if(netStatus){
      dynamic fetchResult = await NetworkService.post(setting.value + SAVING_ACCOUNT_APPROVE, obj, header: {
        "Content-Type":"application/json"
      });
//      print(fetchResult);
      if(fetchResult['status']=="true"){
        return true;
      }else{
        return throw CustomException("Sorry! Unable to post account to ledger", 500);
      }
    }else{
      return throw CustomException("Internet Connection not available", 500);
    }
  }


}