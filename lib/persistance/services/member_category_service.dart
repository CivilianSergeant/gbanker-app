import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/member_categories_table.dart';
import 'package:gbanker/persistance/entities/MemberCategory.dart';
import 'package:sqflite/sqflite.dart';

class MemberCategoryService{

  static Future<void> seedData() async{
    final Database db = await DbProvider.db.database;

    db.rawInsert("INSERT INTO "+MemberCategoriesTable().tableName+" (id, category_code, category_name) VALUES(1, '01.00', 'Prattay'),"

        "(2, '02.00', 'Agraduth'),(3, '03.00', 'Ankur'),(4, '04.00', 'Udhayan');");
//    print('member categories Seed done');

  }

  static Future<void> truncateMemberCategories() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MemberCategoriesTable().tableName);
  }

  static Future<int> addMemberCategory(MemberCategory memberCategory) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(MemberCategoriesTable().tableName, memberCategory.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<int> addMemberCategories(List<dynamic> memberCategories) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic memberCategory in memberCategories){
      batch.insert(MemberCategoriesTable().tableName,MemberCategory(
        id: memberCategory['MemberCategoryID'],
        categoryCode: memberCategory['MemberCategoryCode'],
        categoryName: memberCategory['CategoryName']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<MemberCategory>> getMemberCategories() async {
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(MemberCategoriesTable().tableName);
    return List.generate(maps.length, (i){
      return MemberCategory(
          id: maps[i]['id'],
          categoryCode: maps[i]['category_code'],
          categoryName: maps[i]['category_name']
      );
    });
  }
}