import 'dart:async';

import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Investor.dart';
import 'package:gbanker/persistance/tables/investors_table.dart';
import 'package:sqflite/sqflite.dart';

class InvestorService{

  static Future<void> truncateInvestors() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+InvestorsTable().tableName);
  }

  static Future<List<Map<String,dynamic>>> getInvestors() async{
    final Database db = await DbProvider.db.database;
    return await db.query(InvestorsTable().tableName);
  }

  static Future<int> addInvestors(List<dynamic> investors) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    for(dynamic investor in investors){
      batch.insert(InvestorsTable().tableName,Investor(
          id: investor['InvestorID'],
          investorCode: investor['InvestorCode'],
          investorName: investor['InvestorName'],
          orgId: investor['OrgID'],
          isActive: (investor['IsActive'] == 1) ? true : false,
          isActiveDate: investor['IsActiveDate'],
          createUser: investor['CreateUser'],
          createDate: investor['CreateDate']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }
}