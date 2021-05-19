import 'dart:convert';

import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/LoanCollection.dart';
import 'package:gbanker/persistance/entities/LoanCollectionUpload.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/persistance/tables/loan_collection_history_table.dart';
import 'package:gbanker/persistance/tables/loan_collections_table.dart';
import 'package:gbanker/persistance/tables/member_products_table.dart';
import 'package:gbanker/persistance/tables/withdraw_table.dart';
import 'package:sqflite/sqflite.dart';
class LoanCollectionService{

  static Future<int> addLoanCollection(LoanCollection loanCollection) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(LoanCollectionsTable().tableName, loanCollection.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<int> addLoanCollectionBatch(List<LoanCollection> loanCollections) async {
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    int i=0;
    loanCollections.forEach((lc){
      batch.insert(LoanCollectionsTable().tableName, lc.toMap());
      i++;
    });

    batch.commit(noResult: true);
    return i;
  }

  static Future<void> truncateLoanCollections() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+LoanCollectionsTable().tableName);
    return;
  }

  static Future<int> deleteLoanCollection({int memberId, String idIn}) async {
    final Database db = await DbProvider.db.database;
    int i=0;
    if(memberId!=null) {
      await db.execute("DELETE FROM " + LoanCollectionsTable().tableName +
          " WHERE member_id=" + memberId.toString());
      i=1;
    }

    if(idIn != null){
      await db.execute("DELETE FROM " + LoanCollectionsTable().tableName +
          " WHERE member_id IN (" + idIn.toString()+")");
      i=1;
    }
    return i;
  }

  static Future<int> softDeleteLoanCollection({int memberId, String idIn}) async {
    final Database db = await DbProvider.db.database;
    int i=0;
    if(memberId!=null) {
      await db.execute("UPDATE " + LoanCollectionsTable().tableName +
          " SET is_deleted=1 WHERE member_id=" + memberId.toString());
      i=1;
    }

    if(idIn != null){
      await db.execute("UPDATE " + LoanCollectionsTable().tableName +
          " SET is_deleted=1 WHERE member_id IN (" + idIn.toString()+")");
      i=1;
    }

    if(memberId == null && idIn == null){
      await db.execute("UPDATE " + LoanCollectionsTable().tableName +
          " SET is_deleted=1");
      i=1;
    }
    return i;
  }

  static Future<bool> hasCollection() async {
    final Database db = await DbProvider.db.database;
    String sql="SELECT COUNT(*) as totalCollection FROM "+LoanCollectionsTable().tableName;
    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    bool _hasCollection = false;
    maps.forEach((Map<String,dynamic> map){
      if(map['totalCollection']>0){
        _hasCollection = true;
      }
    });

    return _hasCollection;
  }

  static Future<int> getCollectionCount() async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> collection = await db.rawQuery("SELECT COUNT(*) as member_collected FROM(SELECT COUNT(*) FROM ${LoanCollectionsTable().tableName} WHERE is_deleted=0 GROUP BY member_id)");
    int memberCollected = 0;
    collection.forEach((Map<String,dynamic> c){

      memberCollected = (c['member_collected'] != null)? c['member_collected'] : 0;
    });

    return memberCollected;
  }

  static Future<double> getCollectionAmount() async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> collection = await db.rawQuery("SELECT sum(amount) total FROM ${LoanCollectionsTable().tableName} WHERE is_deleted=0");
    double totalAmountCollected = 0;
    collection.forEach((Map<String,dynamic> c){
      totalAmountCollected = (c['total'] != null)? c['total'] : 0;
    });

    return totalAmountCollected;
  }

  static Future<List<Map<String,dynamic>>> getMemberWiseCollectionList({int centerId}) async {
    final Database db = await DbProvider.db.database;
    var tableName = LoanCollectionsTable().tableName;
    var loanSql = "(Select sum(amount) from ${tableName} WHERE product_type=1 AND member_id=lc.member_id GROUP BY member_id) as loan";
    var savingsSql = "(Select sum(amount) from ${tableName} WHERE product_type=0 AND member_id=lc.member_id GROUP BY member_id) as savings";
    var totalSql = "(Select sum(amount) from ${tableName} WHERE member_id=lc.member_id GROUP BY member_id) as total";

    var sql = "SELECT lc.member_id, mp.member_name,"+loanSql+","+savingsSql+","+totalSql+"  FROM ${tableName} as lc "
        +" JOIN member_products as mp"+
        " ON mp.member_id = lc.member_id"+
        ((centerId != null)? " WHERE lc.center_id="+centerId.toString()+" AND is_deleted=0" :"")
        +" GROUP BY lc.member_id";
    List<Map<String,dynamic>> collections = await db.rawQuery(sql);

    return collections;
  }

  static Future<Map<String,dynamic>> getCenterWiseCollections({int center_id}) async {
    final Database db = await DbProvider.db.database;
    var tableName = LoanCollectionsTable().tableName;
    var productName = "(SELECT product_name from member_products WHERE product_id = lc.product_id) as product_name";
    var sql = "SELECT ${productName},lc.center_id, lc.product_id, sum(lc.loan_recovery) as recoverable, sum(lc.amount) as amount,"
        " (sum(lc.loan_recovery)-sum(lc.amount)) as due, centers.center_code || '-' || centers.center_name AS center_name, lc.is_deleted FROM "+tableName+" as lc"+
        " JOIN centers ON centers.id=lc.center_id "+
        ((center_id != null && center_id != 0)? " WHERE lc.center_id="+center_id.toString()+" AND lc.is_deleted=0":" WHERE lc.is_deleted=0")+
        " GROUP By center_id,product_id"
        " ORDER BY center_id";
    List<Map<String,dynamic>> collections = await db.rawQuery(sql);
//    print(collections);
    List<Map<String,dynamic>> centerWiseTotal = [];
    var centerId = 0;
    var i=0;
    double total = 0;
    double recoverable = 0;
    double due=0;

    Map<String,dynamic> centerTotal;

    collections.forEach((f){

        if(centerId != f['center_id']){

          if(i==0) {
            total = total + f['amount'];
            recoverable = recoverable + f['recoverable'];
            due = due + f['due'];
            centerTotal = {"center_id":f['center_id'],"center_name":f['center_name']};

          }else {

            centerTotal['total']=total;
            centerTotal['recoverable'] = recoverable;
            centerTotal['due'] = due;

            centerTotal['index']=i-1;
            centerWiseTotal.add(centerTotal);

            centerTotal = {"center_id":f['center_id'],"center_name":f['center_name']};

            total=0;
            recoverable = 0;
            due = 0;
            total = total + f['amount'];
            recoverable = recoverable + f['recoverable'];
            due = due + f['due'];

          }

          centerId = f['center_id'];

        }else{

          total=total + f['amount'];
          recoverable = recoverable + f['recoverable'];
          due = due + f['due'];
         // print(f);
        }

        i++;

        if(i==collections.length){
          centerTotal['total']=total;
          centerTotal['recoverable'] = recoverable;
          centerTotal['due'] = due;
          centerTotal['index']=i-1;

          centerWiseTotal.add(centerTotal);
           //print(total.toString());
        }

    });
   // print(centerWiseTotal.toString());

    return {'centerWiseCollections':collections,'centerWiseTotal':centerWiseTotal};
  }

  static Future<List<Map<String,dynamic>>>  getCollections({bool isDeletedOnly}) async{
    final Database db = await DbProvider.db.database;
    var tableName = LoanCollectionsTable().tableName;
    var memberName = "(SELECT member_name from member_products WHERE product_id = lc.product_id AND member_id = lc.member_id) as member_name";
    var centerName = "(SELECT center_name from member_products WHERE product_id = lc.product_id AND center_id = lc.center_id) as center_name";
    var productName = "(SELECT product_name from member_products WHERE product_id = lc.product_id) as product_name";
    var sql = "SELECT ${productName},${memberName},${centerName},lc.center_id, lc.product_id,lc.member_id, recoverable, amount, (lc.recoverable-lc.amount) as due FROM "+tableName+" as lc";

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

  static Future<List<Map<String,dynamic>>>  getCollectionsByDate({String createdDate}) async{
    final Database db = await DbProvider.db.database;
    var tableName = LoanCollectionsTable().tableName;
    var memberName = "(SELECT member_name from member_products WHERE product_id = lc.product_id AND member_id = lc.member_id) as member_name ";
    var memberCode = "(SELECT member_code from member_products WHERE product_id = lc.product_id AND member_id = lc.member_id) as member_code ";
    var officeName = "(SELECT office_name from offices limit 1) as office_name, lc.office_id";
    var centerName = "(SELECT center_name from member_products WHERE product_id = lc.product_id AND center_id = lc.center_id) as center_name";
    var productName = "(SELECT product_name from member_products WHERE product_id = lc.product_id) as product_name";
    var sql = "SELECT lc.id as collection_id,${productName},${officeName},${memberName},${memberCode},${centerName},lc.center_id, lc.product_id,lc.member_id, recoverable, amount, (lc.recoverable-lc.amount) as due, lc.trx_type,lc.product_type,lc.token as guid, lc.summary_id, lc.int_charge,lc.loan_installment,lc.int_installment,lc.created_at FROM "+tableName+" as lc";

    if(createdDate != null){
      sql += " WHERE lc.created_at LIKE '${createdDate}%'";
    }

    List<Map<String,dynamic>> collections = await db.rawQuery(sql);
    return collections;
  }

  static Future<Map<String,dynamic>> getUploadedData() async {
    final Database db = await DbProvider.db.database;
    Setting setting = await SettingService.getSetting("guid");
    User user = await UserService.getUserByGuid(setting.value);
    Setting settingVersion = await SettingService.getSetting("version");
    var tableName = LoanCollectionsTable().tableName;
    var wTableName = WithdrawalsTable().tableName;

    var sql = "SELECT member_id as MemberID, amount as Amount, office_id as OfficeID, center_id as CenterID, "
        " product_id as ProductID, token as Token, id as CollectionID, summary_id as Sid,"
        " trx_type as TType, product_type as PType, int_charge as IntCharge, "
        " loan_installment as LoanInstallment, int_installment as IntInstallment,"
        " fine from ${tableName}";

    var wSql = "SELECT member_id as MemberID, amount as Amount, office_id as OfficeID, center_id as CenterID, "
        " product_id as ProductID, token as Token, id as CollectionID, summary_id as Sid,"
        " trx_type as TType, product_type as PType, int_charge as IntCharge, "
        " loan_installment as LoanInstallment, int_installment as IntInstallment,"
        " fine from ${wTableName}";

      List<Map<String,dynamic>> loanCollections = await db.rawQuery(sql);
      List<Map<String,dynamic>> withdrawals = await db.rawQuery(wSql);
      List<Map<String,dynamic>> lists = [];
      lists.addAll(loanCollections);

      withdrawals.forEach((w){
          var obj = lists.firstWhere((lc)=>lc['Sid'] == w['Sid'], orElse:()=> null);
          if(obj != null){
            obj['IntInstallment'] = w['LoanInstallment'];
          }else{

            lists.add({
              "MemberID": w["MemberID"],
              "Amount": w["Amount"],
              "OfficeID": w["OfficeID"],
              "CenterID": w["CenterID"],
              "ProductID": w["ProductID"],
              "Token": w["Token"],
              "CollectionID": w["CollectionID"],
              "Sid": w["Sid"],
              "TType": w["TType"],
              "PType": w["PType"],
              "IntCharge": w["IntCharge"],
              "IntInstallment": w["LoanInstallment"],
              "LoanInstallment": 0,
              "fine":0
            });
          }
      });


//      print(lists.length);

      DateTime dateTime = DateTime.now();

      LoanCollectionUpload loanCollectionUpload = LoanCollectionUpload(
          dateTime.toString().substring(0,19),
          user.username.toString(),
          settingVersion.value.toString(),
          lists
      );


      return loanCollectionUpload.toMap();

  }

  static Future<void> copyUploadedDataToHistory() async {
    final Database db = await DbProvider.db.database;
    var loanCollectionHistoryTblName = LoanCollectionHistoryTable().tableName;
    var tableName = LoanCollectionsTable().tableName;
    var wTableName = WithdrawalsTable().tableName;

    var sql = "INSERT INTO ${loanCollectionHistoryTblName}(collection_id,"
        "office_id,center_id,product_id,member_id,amount,recoverable,"
        "loan_recovery,summary_id,trx_type,token,product_type,loan_installment,"
        "int_installment,int_charge,fine,installment_date,created_at"
        ") SELECT id,"
        "office_id,center_id,product_id,member_id,amount,recoverable,loan_recovery,"
        "summary_id,trx_type,token,product_type,loan_installment,"
        "int_installment,int_charge,fine,installment_date,created_at FROM ${tableName}";
        await db.execute(sql);

    var wSql = "INSERT INTO ${loanCollectionHistoryTblName}(collection_id,"
        "office_id,center_id,product_id,member_id,amount,recoverable,"
        "loan_recovery,summary_id,trx_type,token,product_type,loan_installment,"
        "int_installment,int_charge,fine,installment_date,created_at"
        ") SELECT id,"
        "office_id,center_id,product_id,member_id,amount,due_amount,loan_recovery,"
        "summary_id,trx_type,token,product_type,0,"
        "loan_installment,int_charge,fine,installment_date,created_at FROM ${wTableName}";

        await db.execute(wSql);


  }
}

