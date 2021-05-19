import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gbanker/config/AppConfiguration.dart';
import 'package:gbanker/config/DSK.dart';
import 'package:gbanker/config/GB.dart';
import 'package:gbanker/config/MFI.dart';
import 'package:gbanker/config/Verc.dart';
import 'package:path_provider/path_provider.dart';

class AppConfig{

  static const String DEV = "devevlopment";
  static const String PROD = "production";
  static const String CONFIG_GB = "GB";
  static const String CONFIG_MFI = "MFI";
  static const String CONFIG_DSK = "DSK";
  static const String CONFIG_VERC = "VERC";

  static const String env = PROD;
  static const String Instance = CONFIG_DSK;

  static AppConfiguration getInstance(){
    if(Instance == CONFIG_GB){
      return GB();
    }
    if(Instance == CONFIG_DSK){
      return DSK();
    }
    if(Instance == CONFIG_VERC){
      return Verc();
    }
    if(Instance == CONFIG_MFI){
      return MFI();
    }
    return null;
  }

  static String getDefaultOrgName(){
    return getInstance().getOrgName();
  }

  static String getDefaultUrl(){
    if(env == DEV){
      return getInstance().getOrgUrl();
    }else if(env == PROD){
      return getInstance().getOrgUrl();
    }
  }

  static String getDefaultPort(){
    if(env == DEV){
      return getInstance().getPort();
    }else if(env == PROD){
      return getInstance().getPort();
    }
  }

  static String getDefaultDomain(){
    if(env == DEV){
      return getInstance().getDomain();
    }else if(env == PROD){
      return getInstance().getDomain();
    }
  }

  static String getImagePath(){
    return '/Pictures/gbanker/';
  }

  static Future<bool> removeImages() async{
    MethodChannel platform = MethodChannel("gbanker/writefile");
    final Directory extDir = (await getExternalStorageDirectory());
    var path = '${extDir.path}${AppConfig.getImagePath()}';
    if(Directory(path).existsSync()) {
      await Directory(path).delete(recursive: true);
      platform.invokeMethod("scanFile",{"path":path});
    }

  }
}