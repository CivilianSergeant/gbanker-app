import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Member.dart';
import 'package:gbanker/persistance/entities/MemberProduct.dart';
import 'package:gbanker/persistance/entities/MemberType.dart';
import 'package:gbanker/persistance/tables/loan_collections_table.dart';
import 'package:gbanker/persistance/tables/member_products_table.dart';
import 'package:gbanker/persistance/tables/products_table.dart';
import 'package:gbanker/persistance/tables/savings_accounts_table.dart';
import 'package:gbanker/persistance/tables/withdraw_table.dart';
import 'package:sqflite/sqflite.dart';

class MemberProductService{

  static Future<int> addMemberProduct(MemberProduct memberProduct) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(MemberProductsTable().tableName, memberProduct.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateMemberProducts() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MemberProductsTable().tableName);
  }

  static Future<int> addMemberProducts(List<dynamic> maps,{Function uiCallback, bool isDownloadSavings}) async{
    try {
      int i = 0;
      final Database db = await DbProvider.db.database;
      Batch batch = db.batch();

      for (dynamic map in maps) {
        var memberProduct = MemberProduct(
          officeId: int.parse(map['OfficeID'].toString()),
          officeCode: map['OfficeCode'].toString(),
          officeName: map['OfficeName'].toString(),
          centerId: map['CenterID'],
          centerCode: map['CenterCode'].toString(),
          centerName: map['CenterName'].toString(),
          memberId: map['MemberID'],
          memberCode: map['MemberCode'].toString(),
          memberName: map['MemberName'].toString(),
          productId: int.parse(map['ProductID'].toString()),
          productCode: map['ProductCode'].toString(),
          productName: map['ProductName'].toString(),
          productType: map['ProductType'],
          loanRecovery: map['LoanRecovery'],
          recoverable: map['Recoverable'],
          balance: map['Balance'],
          installmentDate: map['InstallmentDate'].toString(),
          installmentNo: map['InstallmentNo'],
          trxType: map['TrxType'],
          summaryId: int.parse(map['SummaryID'].toString()),
          prinBalance: map['PrinBalance'],
          serBalance: map['SerBalance'],
          interestCalculationMethod: map['InterestCalculationMethod']
              .toString(),
          duration: int.parse(map['Duration'].toString()),
          durationOverLoanDue: double.parse(
              map['DurationOverLoanDue'].toString()),
          durationOverIntDue: double.parse(
              map['DurationOverIntDue'].toString()),
          loanDue: map['LoanDue'],
          intDue: map['IntDue'],
          cumIntCharge: map['CumIntCharge'],
          cumInterestPaid: map['CumInterestPaid'],
          principalLoan: map['PrincipalLoan'],
          loanRepaid: map['LoanRepaid'],
          intCharge: map['IntCharge'],
          newDue: map['NewDue'],
          mainProductCode: map['MainProductCode'].toString(),
          doc: int.parse(map['Doc'].toString()),
          accountNo: map['accountNo'],
          fine: double.parse(map['fine'].toString()),
          scPaid: map['SCPaid'],
          personalWithdraw: map['PersonalWithdraw'],
          personalSaving: map['PersonalSaving'],
          orgId: int.parse(map['orgID'].toString()),
          cumLoanDue: double.parse(map['CumLoanDue'].toString()),
          cumIntDue: double.parse(map['CumIntDue'].toString()),
          disburseDate: map['DisburseDate'],
          disburseAmount: double.parse(map['DisburseAmount'].toString()),
          allowFine: map['allowFine']

        );

        if (isDownloadSavings != null && isDownloadSavings == true) {
          var _memberProduct = await getMemberBySummaryAndProductType(
              memberProduct.summaryId, memberProduct.productType);
          if (_memberProduct == null) {
            batch.insert(
                MemberProductsTable().tableName, memberProduct.toMap());
          }
        } else {
          batch.insert(MemberProductsTable().tableName, memberProduct.toMap());
        }

        i++;
      }

      await batch.commit(noResult: true);
      return i;
    }on Exception catch(ex){
//      print(ex);
    }
  }

  static Future<MemberProduct> getMemberBySummaryAndProductType(int summaryId, int productType) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> _maps = await db.query(MemberProductsTable().tableName,columns: ["id","member_code","member_name"],where: "summary_id=? AND product_type=?",
        whereArgs:[ summaryId,productType ]);

    MemberProduct memberProduct;
    _maps.forEach((m)=>
      memberProduct = MemberProduct(
        id:m['id'],
        memberName: m['member_name'],
        memberCode: m['member_code']
      )
    );

    return memberProduct;
  }



  static Future<List<MemberProduct>> getMembers({ int centerId, int trxType, bool isWithdrawal }) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = List<Map<String,dynamic>>();
    List<MemberProduct> memberProducts = [];

    var tableName = (isWithdrawal!=null && isWithdrawal==true)? WithdrawalsTable().tableName :  LoanCollectionsTable().tableName;
    int year = DateTime.now().year;
    int m = DateTime.now().month;
    String month = (m<10)? "0"+m.toString() : m.toString();
    int d = DateTime.now().day;
    String day = (d<10)? "0"+d.toString() : d.toString();


    String sql = "SELECT mp.member_id,mp.member_code,mp.member_name FROM ${MemberProductsTable().tableName} mp "
        "LEFT JOIN "+tableName+" lc "
        " ON mp.member_id = lc.member_id AND mp.trx_type = lc.trx_type AND mp.center_id = lc.center_id"
        " WHERE  mp.center_id="+centerId.toString()+ //OR lc.installment_date NOT LIKE '${createdDate}%'
        //((trxType != null)? " AND mp.trx_type="+trxType.toString()+
        " AND lc.member_id IS NULL  ";
        if(trxType!=null) {
          sql +=  " AND mp.trx_type=" + trxType.toString();
        }
        sql+=" GROUP BY mp.member_code ORDER BY mp.member_id ASC";


    maps = await db.rawQuery(sql);

    for(Map<String,dynamic> map in maps){
      memberProducts.add(MemberProduct(
        memberId:map['member_id'],
        memberCode: map['member_code'],
        memberName: map['member_name']
      ));
    }

    return memberProducts;

  }

  static Future<List<MemberProduct>> getCollections({
    int centerId, int memberId, int trxType, bool onlySavings
  }) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = List<Map<String,dynamic>>();
    List<MemberProduct> memberProducts = [];

    if(centerId != null && memberId != null){
      var where = "center_id=? AND member_id=? "+((trxType != null)? " AND trx_type=?":"")
      +((onlySavings!=null && onlySavings)? " AND product_type=0":"");

      var whereArgs = [];

      whereArgs.insert(0, centerId);
      whereArgs.insert(1, memberId);
      if(trxType != null){
        whereArgs.insert(2, trxType);
      }

      maps = await db.query(MemberProductsTable().tableName,
          where: where,
          whereArgs: whereArgs,
      );

      for(Map<String,dynamic> map in maps){
        memberProducts.add(MemberProduct.fromJson(map));
      }
    }

    return memberProducts;

  }

  static Future<List<Map<String,dynamic>>> getProducts({int memberId,
  bool onlySavings}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String, dynamic>> maps;
    if (memberId != null){
        if(onlySavings != null && onlySavings==true){
          maps = await db.query(MemberProductsTable().tableName,
          where:"product_type=0",
          groupBy: "product_code");
        }else {
          maps = await db.query(MemberProductsTable().tableName,
              where: "member_id=?", whereArgs: [memberId]);
        }
    }else{
      maps = await db.query(ProductsTable().tableName);
    }
    return maps;
  }

  static Future<List<Map<String,dynamic>>> getProductsByMember({int memberId,
    String productCodeLike,
    bool onlySavings,
    bool onlyLoan}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String, dynamic>> maps;
    if (memberId != null){
      if(onlySavings != null && onlySavings==true){

        if(productCodeLike!=null){
          maps = await db.query(MemberProductsTable().tableName,
              where:"product_type=0 AND member_id=? AND product_code LIKE '"+productCodeLike+"%'",
              whereArgs: [memberId],
              groupBy: "product_code");
        }else{
          maps = await db.query(MemberProductsTable().tableName,
              where:"product_type=0 AND member_id=?",
              whereArgs: [memberId],
              groupBy: "product_code");
        }

      }else if(onlyLoan !=null){
        maps = await db.query(MemberProductsTable().tableName,
            where:"product_type=1 AND member_id=?",
            whereArgs: [memberId],
            groupBy: "product_code");
      }else {
        maps = await db.query(MemberProductsTable().tableName,
            where: "member_id=?", whereArgs: [memberId]);
      }
    }else{
      maps = await db.query(ProductsTable().tableName);
    }
    return maps;
  }

  static Future<List<Map<String,dynamic>>> getAccountsByProduct(int memberId,int productId) async{
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT summary_id,account_no FROM ${MemberProductsTable().tableName} mp "
        " WHERE member_id=${memberId} AND product_id=${productId}");
    return maps;
  }

  static Future<int> getNumberOfProducts(int memberId, int productId) async {

    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps;
    maps = await db.rawQuery("SELECT count(id) as total "
        " FROM ${MemberProductsTable().tableName}"
        " WHERE member_id=${memberId} AND product_id=${productId} ");
    int total = 0;
    maps.forEach((Map<String,dynamic> map){
      total = (map['total']);
    });
    maps = await db.rawQuery("SELECT count(id) as total"
        " FROM ${SavingsAccountsTable().tableName} WHERE member_id=${memberId} AND product_id=${productId}");

    maps.forEach((Map<String,dynamic> map){
      total += (map['total']);
    });


    return (total+1);
  }

}