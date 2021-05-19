import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Purpose.dart';
import 'package:gbanker/persistance/tables/purposes_table.dart';
import 'package:sqflite/sqflite.dart';

class PurposeService{

  static Future<void> truncatePurposes() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+PurposesTable().tableName);
  }

  static Future<List<Map<String,dynamic>>> getPurposes() async{
    final Database db = await DbProvider.db.database;
    return await db.query(PurposesTable().tableName);
  }

  static Future<int> addPurposes(List<dynamic> purposes) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    for(dynamic purpose in purposes){
      batch.insert(PurposesTable().tableName,Purpose(
          id: purpose['PurposeID'],
          purposeCode: purpose['PurposeCode'],
          purposeName: purpose['PurposeName'],
          orgId: purpose['OrgID'],
          isActive: (purpose['IsActive'] == 1) ? true : false,
          isActiveDate: purpose['IsActiveDate'],
          createUser: purpose['CreateUser'],
          createDate: purpose['CreateDate'],
          mainSector: purpose['MainSector'],
          mainSectorName: purpose['MainSectorName'],
          subSector: purpose['SubSector'],
          subSectorName: purpose['SubSectorName'],
          mainLoanSector: purpose['MainLoanSector']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }
}