import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/GroupType.dart';
import 'package:gbanker/persistance/tables/grouptypes_table.dart';
import 'package:sqflite/sqflite.dart';

class GroupTypeService{
  
  static Future<int> addGroupType(GroupType groupType) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(GroupTypeTable().tableName, groupType.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateGroupTypes() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+GroupTypeTable().tableName);
  }

  static Future<int> addGroupTypes(List<dynamic> groupTypes) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic groupType in groupTypes){
      batch.insert(GroupTypeTable().tableName,GroupType(
        text: groupType['Text'],
        value: groupType['Value'],
        selected: (groupType['Selected']=="true")? true : false
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<GroupType>> getGroupTypes() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(GroupTypeTable().tableName);

    return List.generate(maps.length, (i){
      return GroupType(
          id: maps[i]['id'],
          text: maps[i]['text'],
          value: maps[i]['value'],
          selected: (maps[i]['selected']==1)? true : false,
      );
    });
  }
}