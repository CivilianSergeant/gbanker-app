
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:gbanker/config/app_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHelper{

  static const int PHOTO=1;
  static const int SIG=2;

  static Future<bool> writeImage(type,String content, {int memberId,Function callback}) async {

    final Directory extDir = (await getExternalStorageDirectory());
    final String dirPath = '${extDir.path}${AppConfig.getImagePath()}'+((type==PHOTO)? 'images' : 'signatures');

    Directory directory = await Directory(dirPath).create(recursive: true);
    final String filePath = '${dirPath}/${timestamp()}.jpg';

    Uint8List bytes = base64Decode(content);
    File f = File(filePath);
    f.writeAsBytesSync(bytes);

    if(callback != null){
      callback(filePath,memberId,sync:true);
    }

  }

  static String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  static Future<bool> hasPermission() async {
    PermissionStatus storagePermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    Map<PermissionGroup,PermissionStatus> map;
    if (PermissionStatus.denied == storagePermission) {
       map = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);

//       print(map);
    }
    PermissionStatus cameraPermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (PermissionStatus.denied == cameraPermission) {
      map = await PermissionHandler()
          .requestPermissions([PermissionGroup.camera]);

//      print(map);
    }
  }



}