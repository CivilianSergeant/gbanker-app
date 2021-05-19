import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/divisions_table.dart';
import 'package:gbanker/persistance/entities/Division.dart';
import 'package:sqflite/sqflite.dart';

class DivisionService{

  static Future<void> seedData() async {
    final Database db = await DbProvider.db.database;
    db.rawInsert("INSERT INTO "+DivisionsTable().tableName+" (id,country_id, division_code, division_name) "
        "VALUES(6, 18, '6', 'Sylhet'),(2, 18, '2', 'Chattogram'),(4,18, '4', 'Khulna'),"
        "(1,18, '1', 'Barishal'),(3,18, '3', 'Dhaka'),(8,18, '8', 'Mymensingh'),(5,18, '5', 'Rajshahi'),(7,18, '7', 'Rangpur');");
//    print('Division Seed done');
  }

  static Future<void> truncateDivisions() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+DivisionsTable().tableName);
  }

  static Future<int> addDivision(Division division) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(DivisionsTable().tableName, division.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<int> addDivisions(List<dynamic> divisions) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic division in divisions){

      if(division['DivisionCode'] != null && division['DivisionName'] != null) {

        Map<String, dynamic> map = Division(

            id: int.parse(division['DivisionCode']),
            divisionCode: division['DivisionCode'],
            divisionName: division['DivisionName'],
            countryId: division['CountryID']

        ).toMap();

        batch.insert(DivisionsTable().tableName,map);
        i++;
      }

    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<Division>> getDivisions({int countryId}) async{
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = List<Map<String,dynamic>>();
    if(countryId > 0){
      maps = await db.query(DivisionsTable().tableName,where:"country_id=?",whereArgs: [countryId] );
    }else{
      maps = await db.query(DivisionsTable().tableName);
    }

    return List.generate(maps.length, (i){
      return Division(
          id: maps[i]['id'],
          countryId: maps[i]['country_id'],
          divisionCode: maps[i]['division_code'],
          divisionName: maps[i]['division_name']
      );
    });
  }
}