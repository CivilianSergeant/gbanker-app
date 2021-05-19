import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/sub_districts_table.dart';
import 'package:gbanker/persistance/entities/SubDistrict.dart';
import 'package:sqflite/sqflite.dart';

class SubDistrictService{

  static Future<void> seedData() async{
    final Database db = await DbProvider.db.database;
    db.rawInsert("INSERT INTO "+SubDistrictsTable().tableName+" (id,district_id, sub_district_code, sub_district_name) "
        "VALUES(38273,382, '38273', 'Pangsha'),(38276,382, '38276', 'Rajbari Sadar'),(38229,382, '38229', 'Goalandaghat'),"
        "(38207,382, '38207', 'Balia Kandi'),(5,'382', '05', 'Kalukhali'),(310,'382', '310', 'Baliakandi');");

//    print('Sub district seed done');
  }

  static Future<void> truncateSubDistricts() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+SubDistrictsTable().tableName);
  }

  static Future<int> addSubDistrict(SubDistrict subDistrict) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(SubDistrictsTable().tableName, subDistrict.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<int> addSubDistricts(List<dynamic> subDistricts) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic subDistrict in subDistricts){
      batch.insert(SubDistrictsTable().tableName,SubDistrict(
        subDistrictCode: subDistrict['UpozillaCode'],
        districtId: int.parse(subDistrict['DistrictCode']),
        subDistrictName: subDistrict['UpozillaName']
      ).toMap());

      i++;
    }

    await batch.commit(noResult: true);

    return i;
  }

  static Future<List<SubDistrict>> getSubDistricts({int districtId}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = List<Map<String,dynamic>>();
    if(districtId  > 0){
      maps = await db.query(SubDistrictsTable().tableName,where:"district_id=?",
      whereArgs: [districtId]);
    }else{
      maps = await db.query(SubDistrictsTable().tableName);
    }

    return List.generate(maps.length, (i){
      return SubDistrict(
        id : maps[i]['id'],
        districtId: maps[i]['district_id'],
        subDistrictCode: maps[i]['sub_district_code'],
        subDistrictName: maps[i]['sub_district_name']
      );
    });
  }
}