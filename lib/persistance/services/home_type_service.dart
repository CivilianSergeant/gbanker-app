import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/HomeType.dart';
import 'package:gbanker/persistance/tables/hometypes_table.dart';
import 'package:sqflite/sqflite.dart';

class HomeTypeService{
  
  static Future<int> addHomeType(HomeType homeType) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(HomeTypeTable().tableName, homeType.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateHomeTypes() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+HomeTypeTable().tableName);
  }

  static Future<int> addHomeTypes(List<dynamic> homeTypes) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic homeType in homeTypes){
      batch.insert(HomeTypeTable().tableName,HomeType(
        text: homeType['Text'],
        value: homeType['Value'],
        selected: (homeType['Selected']=="true")? true : false
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<HomeType>> getHomeTypes() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(HomeTypeTable().tableName);

    return List.generate(maps.length, (i){
      return HomeType(
          id: maps[i]['id'],
          text: maps[i]['text'],
          value: maps[i]['value'],
          selected: (maps[i]['selected']==1)? true : false,
      );
    });
  }
}