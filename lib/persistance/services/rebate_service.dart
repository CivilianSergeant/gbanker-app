import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';

class RebateService{


  static const REBATE_CAL = "api/rebate/calculate";

  static Future<Map<String,dynamic>> getCalulation(Map<String,dynamic> postData) async{
    bool netStatus = await NetworkService.check();
    if(!netStatus){
      throw CustomException("Internet is not available",500);
    }

    Setting setting = await SettingService.getSetting("orgUrl");

    Map<String,dynamic> map = await NetworkService.post(setting.value+REBATE_CAL, postData, header: {
      "Content-Type":"application/json"
    });

    if(map!= null && map['status'] == "true"){
      return map['rebate'];
    }else{
      throw CustomException("Sorry! Try again later",500);
    }
  }

}