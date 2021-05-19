import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/unions_table.dart';
import 'package:gbanker/persistance/entities/Union.dart';
import 'package:sqflite/sqflite.dart';

class UnionService{

  static Future<void> seedData() async {
    final Database db = await DbProvider.db.database;
    db.rawInsert("INSERT INTO "+UnionsTable().tableName+" (sub_district_code, union_code, union_name) "
        "VALUES('38276', '0885', 'Rajbari Pourasava'),('38276', '0887', 'Baniboha'),('38276', '0888', 'Borat'),('38276', '0892', 'Pachuria'),"
        "('38276', '1080', 'Khan Khanapur'),('38276', '1081', 'Mulghor'),('38276', '1082', 'Shahid Ohabpur'),('38276', '16  ', 'Mukundia'),"
        "('38276', '3827601', 'Ward No-01'),('38276', '3827602', 'Ward No-02'),('38276', '3827603', 'Ward No-03'),('38276', '3827607', 'Alipur'),"
        "('38276', '3827614', 'Banibaha'),('38276', '3827621', 'Barat'),('38276', '3827629', 'Basantapur'),('38276', '3827632', 'Chandani'),"
        "('38276', '3827636', 'Dadshi'),('38276', '3827643', 'Khankhanapur'),('38276', '3827645', 'Khanganj'),('38276', '3827651', 'Mizanpur'),"
        "('38276', '3827658', 'Mulghar'),('38276', '3827665', 'Panchuria'),('38276', '3827680', 'Ramkantapur'),('38276', '3827687', 'Shahid Wahabpur'),"
        "('38276', '3827694', 'Sultanpur');");
//    print('Union seed done');
  }

  static Future<void> truncateUnions() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+UnionsTable().tableName);
  }

  static Future<int> addUnion(Union union) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(UnionsTable().tableName, union.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<int> addUnions(List<dynamic> unions) async {
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic union in unions){
      batch.insert(UnionsTable().tableName,Union(
        subDistrictCode: union['UpozillaCode'].toString(),
        unionCode: union['UnionCode'].toString(),
        unionName: union['UnionName']
      ).toMap());
      i++;
    }

    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<Union>> getUnions({String subDistrictId}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = List<Map<String,dynamic>>();

    if(subDistrictId != null){
      maps = await db.query(UnionsTable().tableName,where: "sub_district_code=?",
        whereArgs: [subDistrictId]);
    }else{
      maps = await db.query(UnionsTable().tableName);
    }

    return List.generate(maps.length, (i){
      return Union(
        id: maps[i]['id'],
        subDistrictCode: maps[i]['sub_district_code'],
        unionCode: maps[i]['union_code'],
        unionName: maps[i]['union_name']

      );
    });
  }
}