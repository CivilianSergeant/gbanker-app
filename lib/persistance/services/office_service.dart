import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/offices_table.dart';
import 'package:gbanker/persistance/entities/Office.dart';
import 'package:sqflite/sqflite.dart';

class OfficeService{
  static Future<void> seedData() async{
    final Database db = await DbProvider.db.database;
    db.execute("INSERT INTO "+OfficesTable().tableName+
        " (office_id, office_code, office_name) "
        "VALUES(28, '0192', 'Boalmari Branch');");
//    print('Office Seed done');
  }

  static Future<int> addOffice(Office office) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(OfficesTable().tableName, office.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateOffice() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+OfficesTable().tableName);
  }


  static Future<List<Office>> getOffices() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(OfficesTable().tableName);

    return List.generate(maps.length, (i){
      return Office(
        id: maps[i]['id'],
        officeId: maps[i]['office_id'],
        officeCode: maps[i]['office_code'],
        officeName: maps[i]['office_name']
      );
    });
  }
}