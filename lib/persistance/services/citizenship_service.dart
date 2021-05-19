import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Citizenship.dart';
import 'package:gbanker/persistance/tables/citizenships_table.dart';
import 'package:sqflite/sqflite.dart';

class CitizenshipService{
  
  static Future<int> addCtitizenship(Citizenship citizenship) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(CitizenshipTable().tableName, citizenship.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateCitizenship() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+CitizenshipTable().tableName);
  }

  static Future<int> addCitizenships(List<dynamic> citizenships) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    for(dynamic citizenship in citizenships){
      batch.insert(CitizenshipTable().tableName,Citizenship(
        text: citizenship['Text'],
        value: citizenship['Value'],
        selected: (citizenship['Selected']=="true")? true: false
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<Citizenship>> getCitizenships() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(CitizenshipTable().tableName);

    return List.generate(maps.length, (i){
      return Citizenship(
          id: maps[i]['id'],
          text: maps[i]['text'],
          value: maps[i]['value'],
          selected: (maps[i]['selected']==1)? true : false,
      );
    });
  }
}