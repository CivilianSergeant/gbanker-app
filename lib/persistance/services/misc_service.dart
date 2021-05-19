import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Misc.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/tables/miscs_table.dart';
import 'package:sqflite/sqflite.dart';

class MiscService{

  static const MISC_SAVE = "api/misc/save";
  static const MISC_DEL = "api/misc/delete";

  static Future<void> truncateMisc() async{
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MiscsTable().tableName);
  }

  static Future<int> addMisc(Map<String,dynamic> misc) async{
    final Database db = await DbProvider.db.database;
    bool netStatus = await NetworkService.check();
    if(!netStatus){
      throw CustomException("Internet not available",500);
    }
    var _misc = Misc(
        officeId: misc['officeId'],
        memberId:  misc['memberId'],
        centerId: misc['centerId'],
        productId: misc['productId'],
        amount: double.parse(misc['amount']),
        transDate: misc['transDate'],
        remarks: misc['remarks']
    );
    Setting url = await SettingService.getSetting("orgUrl");
    Map<String,dynamic> result = await NetworkService.post(url.value+MISC_SAVE, misc,header:{
      "Content-Type":"application/json"
    });
    if(result != null){
      if(result['status'] == "true") {
        Map<String,dynamic> data = {};
        data.addAll(_misc.toMap());
        data.addAll({"misc_id":result['mer']['MiscellaneousId']});
//        print(data);
        int inserted = await db.insert(MiscsTable().tableName, data,
            conflictAlgorithm: ConflictAlgorithm.replace);
        return inserted;
      }else{
        throw CustomException(result['message'],500);
      }
    }else{
      throw CustomException("Sorry! Try again",500);
    }
  }

  static Future<List<Map<String,dynamic>>> getMiscs() async {
    final Database db = await DbProvider.db.database;
    String sql = "SELECT miscs.id, miscs.misc_id,miscs.member_id,miscs.office_id,miscs.product_id,miscs.center_id, (member_code || ' ' || first_name) as member_name, (center_code || ' ' || center_name) as center_name,"
        "amount , (p.product_code || ' ' || p.product_name) as product_name from miscs "
        "LEFT JOIN members m ON m.member_id = miscs.member_id "
        "LEFT JOIN products p ON p.product_id = miscs.product_id "
        "LEFT JOIN centers c ON c.id = miscs.center_id ORDER BY miscs.id DESC";
    return db.rawQuery(sql);
  }

  static Future<int> deleteMisc(Map<String,dynamic> postData) async{
    final Database db = await DbProvider.db.database;
    bool netStatus = await NetworkService.check();
    if(!netStatus){
      throw CustomException("Internet not available",500);
    }
    Setting url = await SettingService.getSetting("orgUrl");

    Map<String,dynamic> result = await NetworkService.post(url.value+MISC_DEL, postData,header:{
      "Content-Type":"application/json"
    });

    if(result != null){
      if(result['status'] == "true") {
        return await db.delete(MiscsTable().tableName,where:"id=?",whereArgs: [postData['id']]);
      }else{

        throw CustomException(result['message'],500);
      }
    }else{
      throw CustomException("Sorry! Try again",500);
    }

  }



}