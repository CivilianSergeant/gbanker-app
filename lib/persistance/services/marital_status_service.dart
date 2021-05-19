import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/MaritalStatus.dart';
import 'package:gbanker/persistance/tables/marital_status_table.dart';
import 'package:sqflite/sqflite.dart';

class MaritalStatusService{
  
  static Future<int> addMaritalStatus(MaritalStatus maritalStatus) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(MaritalStatusTable().tableName, maritalStatus.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateMaritalStatus() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MaritalStatusTable().tableName);
  }

  static Future<int> addMaritalStatuses(List<dynamic> maritalStatuses) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic maritalStatus in maritalStatuses){
      batch.insert(MaritalStatusTable().tableName,MaritalStatus(
        text: maritalStatus['Text'],
        value: maritalStatus['Value'],
        selected: (maritalStatus['Selected']=="true")? true : false
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<MaritalStatus>> getMaritalStatuses() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(MaritalStatusTable().tableName);

    return List.generate(maps.length, (i){
      return MaritalStatus(
          id: maps[i]['id'],
          text: maps[i]['text'],
          value: maps[i]['value'],
          selected: (maps[i]['selected']==1)? true : false,
      );
    });
  }
}