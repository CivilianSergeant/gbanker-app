import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/MaritalStatus.dart';
import 'package:gbanker/persistance/entities/MemberType.dart';
import 'package:gbanker/persistance/tables/marital_status_table.dart';
import 'package:gbanker/persistance/tables/member_types_table.dart';
import 'package:sqflite/sqflite.dart';

class MemberTypeService{
  
  static Future<int> addMemberType(MemberType memberType) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(MemberTypesTable().tableName, memberType.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateMemberTypes() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MemberTypesTable().tableName);
  }

  static Future<int> addMemberTypes(List<dynamic> memberTypes) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic memberType in memberTypes){
      batch.insert(MemberTypesTable().tableName,MemberType(
        text: memberType['Text'],
        value: memberType['Value'],
        selected: (memberType['Selected']=="true")? true : false
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<MemberType>> getMemberTypes() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(MemberTypesTable().tableName);

    return List.generate(maps.length, (i){
      return MemberType(
          id: maps[i]['id'],
          text: maps[i]['text'],
          value: maps[i]['value'].toString(),
          selected: (maps[i]['selected']==1)? true : false,
      );
    });
  }
}