import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/groups_table.dart';
import 'package:gbanker/persistance/entities/Group.dart';
import 'package:sqflite/sqflite.dart';

class GroupService{

  static Future<void> seedData() async {
    final Database db = await DbProvider.db.database;
    db.rawInsert("INSERT INTO "+GroupsTable().tableName+" (id,group_code) VALUES"
        " (9383,'0'),(74,'1'),(75,'2'),(76,'3'),(77,'4'),(78,'5'),(79,'6'),"
        "(80,'7'),(81,'8');");
//    print('Group Seed done');
  }

  static Future<void> truncateGroups() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+GroupsTable().tableName);
  }

  static Future<int> addGroup(Group group) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(GroupsTable().tableName, group.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);

    return inserted;
  }

  static Future<int> addGroups(List<dynamic> groups) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic group in groups){
      batch.insert(GroupsTable().tableName,Group(
          id: group['GroupID'],
          groupCode: group['GroupCode'],
          officeId: group['OfficeID']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<Group>> getGroups() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(GroupsTable().tableName);

    return List.generate(maps.length, (i){
      return Group(
          id: maps[i]['id'],
          groupCode: maps[i]['group_code'],

      );
    });
  }
}