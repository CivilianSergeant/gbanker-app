import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Education.dart';
import 'package:gbanker/persistance/tables/educations_table.dart';
import 'package:sqflite/sqflite.dart';

class EducationService{
  
  static Future<int> addEducation(Education education) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(EducationsTable().tableName, education.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateEducations() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+EducationsTable().tableName);
  }

  static Future<int> addEducations(List<dynamic> educations) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    for(dynamic education in educations){
      batch.insert(EducationsTable().tableName,Education(
        text: education['Text'],
        value: education['Value'],
        selected: (education['Selected']=="true")? true : false
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<Education>> getEducations() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(EducationsTable().tableName);

    return List.generate(maps.length, (i){
      return Education(
          id: maps[i]['id'],
          text: maps[i]['text'],
          value: maps[i]['value'].toString(),
          selected: (maps[i]['selected']==1)? true : false,
      );
    });
  }
}