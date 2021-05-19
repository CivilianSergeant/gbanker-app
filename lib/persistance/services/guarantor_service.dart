import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/guarantors_table.dart';
import 'package:sqflite/sqflite.dart';

class GuarantorService{

  static Future<void> truncateGuarantors() async{
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+GuarantorsTable().tableName);
  }

}