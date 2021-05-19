import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';

class CsRefundService{

  static const CS_REFUND_CAL_SAVE = "api/cs-refund/calculate";


  static Future<Map<String,dynamic>> getCalulation(Map<String,dynamic> postData) async{
    bool netStatus = await NetworkService.check();
    if(!netStatus){
      throw CustomException("Internet is not available",500);
    }

    Setting setting = await SettingService.getSetting("orgUrl");

    Map<String,dynamic> map = await NetworkService.post(setting.value+CS_REFUND_CAL_SAVE, postData, header: {
      "Content-Type":"application/json"
    });

    if(map!= null && map['status'] == "true"){
      return map['csRefundGetResult'];
    }else{
      throw CustomException("Sorry! Try again later",500);
    }


  }

}