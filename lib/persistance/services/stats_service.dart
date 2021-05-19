import 'package:gbanker/persistance/db_provider.dart';
import 'package:sqflite/sqflite.dart';

class StatsService{

  static Future<int> getBorrowerCount(int centerId) async {
    Database db = await DbProvider.db.database;
    String sql = "select count(*) as total_borrower from member_products where product_type=1 AND center_id=${centerId}";
    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    return (maps.length>0)? (maps.first)['total_borrower'] : 0;
  }

  static Future<double> getRecoverableCount(int centerId) async {
    Database db = await DbProvider.db.database;
    String sql = "select sum(recoverable) as total_recoverable from member_products where trx_type=1 AND product_type=1 AND center_id=${centerId} GROUP BY center_id";
    List<Map<String,dynamic>> maps = await db.rawQuery(sql);

    return (maps.length>0)? (maps.first)['total_recoverable'] : 0;
  }

  static Future<double> getTotalLoanOutstanding(int centerId) async {
    Database db = await DbProvider.db.database;
    String sql = "select sum(balance) as total_balance from member_products where product_type=1 AND center_id=${centerId} GROUP BY center_id";
    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    return (maps.length>0)? (maps.first)['total_balance'] : 0;
  }

  static Future<double> getTotalSavingsAmount(int centerId) async {
    Database db = await DbProvider.db.database;
    String sql = "select sum(balance) as total_balance from member_products where product_type=0 AND center_id=${centerId} GROUP BY center_id";
    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    return (maps.length>0)? (maps.first)['total_balance'] : 0;
  }

  static Future<double> getTotalDueAmount(int centerId) async {
    Database db = await DbProvider.db.database;
    String sql = "SELECT sum(mp.new_due+mp.recoverable-coalesce(lc.amount,0)) as due_recoverable"
        " FROM member_products mp LEFT JOIN loan_collections lc "
        " ON lc.center_id = mp.center_id AND lc.member_id = mp.member_id AND lc.product_id = mp.product_id"
        " WHERE mp.product_type=1 AND mp.center_id=${centerId} GROUP BY mp.center_id";

    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    print(maps);
    return (maps.length>0)? (maps.first)['due_recoverable'] : 0;
  }
}