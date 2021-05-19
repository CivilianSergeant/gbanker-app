import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/member_address_table.dart';
import 'package:sqflite/sqflite.dart';

class MemberAddressService{

  static Future<void> truncateMemberAddress() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MemberAddressTable().tableName);
  }

}