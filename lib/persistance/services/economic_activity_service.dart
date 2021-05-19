import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/EconomicActivity.dart';
import 'package:gbanker/persistance/tables/economic_activities_table.dart';
import 'package:sqflite/sqflite.dart';

class EconomicActivityService{
  
  static Future<int> addEconomicActivity(EconomicActivity economicActivity) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(EconomicActivitiesTable().tableName, economicActivity.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateEconomicActivities() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+EconomicActivitiesTable().tableName);
  }

  static Future<int> addEconomicActivities(List<dynamic> economicActivities) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic economicActivity in economicActivities){
      batch.insert(EconomicActivitiesTable().tableName,EconomicActivity(
        text: economicActivity['Text'],
        value: economicActivity['Value'],
        selected: (economicActivity['Selected']=="true")? true : false
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<EconomicActivity>> getEconomicActivities() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(EconomicActivitiesTable().tableName);

    return List.generate(maps.length, (i){
      return EconomicActivity(
          id: maps[i]['id'],
          text: maps[i]['text'],
          value: maps[i]['value'],
          selected: (maps[i]['selected']==1)? true : false,
      );
    });
  }
}