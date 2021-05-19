import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Bank.dart';
import 'package:gbanker/persistance/tables/banks_table.dart';
import 'package:sqflite/sqflite.dart';

class BankService{

  static Future<void> truncateCenters() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+BanksTable().tableName);
  }

  static Future<List<Bank>> getBanks() async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.query(BanksTable().tableName);
    List<Bank> banks = [];
    maps.forEach((map){
      banks.add(Bank(
        bankName: map['bank_name'],
        bankCode: map['bank_code']
      ));
    });

    return banks;
  }


  static Future<int> addBanks(List<dynamic> banks,{Function uiCallback}) async{
    final Database db = await DbProvider.db.database;
    int i=0;
    Batch batch = db.batch();
    for(dynamic bank in banks){
      batch.insert(BanksTable().tableName,(Bank(

          bankCode: bank['BankCode'],
          bankName: bank['BankName'],

      )).toMap());



      i++;
    }

    await batch.commit(noResult: true);

    //print("CENTER ADDED");
    return i;
  }

}