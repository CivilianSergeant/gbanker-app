import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

abstract class NetworkService{

  static Future<Map<String,dynamic>> fetch(String url) async {

    try{
      final response = await http.get(url);
      final parsedJson = jsonDecode(response.body);
      return parsedJson;
    }on Exception catch(ex){
      return null;
    }
  }

  static Future<dynamic> post(String url, Map<String,dynamic> data, {Map<String,String> header}) async{

    var _data = (header['Content-Type'].contains("json"))? jsonEncode(data) : data;
    final response = await http.post(url,body: _data,headers: header);
    final parsedJson = (response.body != null )? jsonDecode(response.body) : null;
    return parsedJson;
  }

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile){
      return true;
    }else if(connectivityResult == ConnectivityResult.wifi){
      return true;
    }else{
      return false;
    }
  }

}