import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Citizenship.dart';
import 'package:gbanker/persistance/entities/Gender.dart';
import 'package:gbanker/persistance/tables/genders_table.dart';
import 'package:sqflite/sqflite.dart';

class GenderService{
  
  static Future<int> addGender(Gender gender) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(GendersTable().tableName, gender.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateGenders() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+GendersTable().tableName);
  }

  static Future<int> addGenders(List<dynamic> genders) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic gender in genders){
      batch.insert(GendersTable().tableName,Gender(
        text: gender['Text'],
        value: gender['Value'],
        selected: (gender['Selected']=="true")? true : false
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<Gender>> getGenders() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(GendersTable().tableName);

    return List.generate(maps.length, (i){
      return Gender(
          id: maps[i]['id'],
          text: maps[i]['text'],
          value: maps[i]['value'],
          selected: (maps[i]['selected']==1)? true : false,
      );
    });
  }
}