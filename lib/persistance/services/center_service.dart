import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/centers_table.dart';
import 'package:gbanker/persistance/entities/Center.dart';
import 'package:gbanker/persistance/tables/loan_collection_history_table.dart';
import 'package:gbanker/persistance/tables/loan_collections_table.dart';
import 'package:gbanker/persistance/tables/member_products_table.dart';
import 'package:sqflite/sqflite.dart';

class CenterService{

  static Future<void> seedData() async{
    final Database db = await DbProvider.db.database;
    db.rawInsert("INSERT INTO "+CentersTable().tableName+" (id, center_code, center_name) VALUES(811, '1005', 'Moyna'),"
        "(819, '1016', 'Dhulpukuria'),(821, '1018', 'Amgram'),(823, '1020', 'Kushadanga'),"
    "(824, '1021', 'Baguan'),(827, '1026', 'Moyna'),(838, '1040', 'Baguan'),"
    "(848, '1062', 'Chalinagar'),(861, '1082', 'Shibpur'),(863, '1085', 'Keyagram'),"
    "(881, '2006', 'Samity-6'),(5414, '1105', ' Baikhir');");
//    print('Center Seed done');

  }

  static Future<int> addCenter(Center center) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(CentersTable().tableName, center.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateCenters() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+CentersTable().tableName);
  }

  static Future<int> addCenters(List<dynamic> centers,{Function uiCallback}) async{
     final Database db = await DbProvider.db.database;
      int i=0;
      Batch batch = db.batch();
      for(dynamic center in centers){
        batch.insert(CentersTable().tableName,(Center(
            id: center['CenterID'],
            centerCode: center['CenterCode'],
            centerName: center['CenterName'],
            officeId: center['OfficeID']
        )).toMap());



        i++;
      }

     await batch.commit(noResult: true);

    //print("CENTER ADDED");
    return i;
  }


  static Future<List<Center>> getCenters({int trxType,bool onlyCollectedCenter,
  bool isDeleted
  }) async{


    final Database db = await DbProvider.db.database;
    String sql = "SELECT "
        "c.id, c.center_code, c.center_name FROM ${CentersTable().tableName}  c "
        "INNER JOIN ${MemberProductsTable().tableName} mp "
        "ON c.id = mp.center_id ";
    if(onlyCollectedCenter != null && onlyCollectedCenter==true){

      sql += " JOIN ${LoanCollectionsTable().tableName} lc"
          " ON lc.center_id = c.id";
      if(isDeleted != null){
        sql += " AND is_deleted=";
        if(isDeleted){
          sql+= "1";
        }else{
          sql+= "0";
        }
      }
    }
    if(trxType != null) {
      sql += "WHERE mp.trx_type=" + trxType.toString();
    }

    sql += " GROUP BY c.id";
    final List<Map<String,dynamic>> maps = await db.rawQuery(sql);

    return List.generate(maps.length, (i){
      return Center(
          id: maps[i]['id'],
          centerCode: maps[i]['center_code'],
          centerName: maps[i]['center_name']
      );
    });
  }

  static Future<List<Center>> getUploadedCenters({int trxType,bool onlyCollectedCenter,
    bool isDeleted
  }) async{


    final Database db = await DbProvider.db.database;
    String sql = "SELECT "
        "c.id, c.center_code, c.center_name FROM ${CentersTable().tableName}  c "
        "INNER JOIN ${LoanCollectionHistoryTable().tableName} mp "
        "ON c.id = mp.center_id ";
    if(onlyCollectedCenter != null && onlyCollectedCenter==true){

      sql += " JOIN ${LoanCollectionsTable().tableName} lc"
          " ON lc.center_id = c.id";
      if(isDeleted != null){
        sql += " AND is_deleted=";
        if(isDeleted){
          sql+= "1";
        }else{
          sql+= "0";
        }
      }
    }
    if(trxType != null) {
      sql += "WHERE mp.trx_type=" + trxType.toString();
    }

    sql += " GROUP BY c.id";
    final List<Map<String,dynamic>> maps = await db.rawQuery(sql);

    return List.generate(maps.length, (i){
      return Center(
          id: maps[i]['id'],
          centerCode: maps[i]['center_code'],
          centerName: maps[i]['center_name']
      );
    });
  }
}