import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> generateCsv({List<Map<String,dynamic>> data,String filename}) async {

  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  MethodChannel platform = MethodChannel("gbanker/writefile");
  final String dir = (await getExternalStorageDirectory()).path;

  if(!dir.contains("/dev/null")) {
    if (PermissionStatus.denied == permission) {
       await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
    } else {
       List<List<String>> _data = [
        <String>["Collection ID","Member Code","Member Name","Amount","Office Name", "Center Name","Product Name","Product ID",
            "Center ID", "Office ID", "Member ID", "Due Amount", "Trx Type", "Product Type", "GUID","Summary ID","Created At"]
      ];

      data.forEach((c){
        _data.add([
          c['collection_id'].toString(),
          c['member_code'].toString(),
          c['member_name'].toString(),
          c['amount'].toString(),
          c['office_name'].toString(),
          c['center_name'].toString(),
          c['product_name'].toString(),
          c['product_id'].toString(),
          c['center_id'].toString(),
          c['office_id'].toString(),
          c['member_id'].toString(),
          c['due'].toString(),
          c['trx_type'].toString(),
          c['product_type'].toString(),
          c['guid'].toString(),
          c['summary_id'].toString(),
          c['created_at'].toString()
        ]);
      });

      String csv = ListToCsvConverter().convert(_data);
      final String dir = (await getExternalStorageDirectory()).path;
      final String path = '${dir}/Android/data/gbanker/${((filename != null)
          ? filename
          : 'untitled.csv')}';

      final File file = File(path);

      if (await file.exists()) {
        await file.writeAsString(csv);
      } else {
        await file.create(recursive: true);
        await file.writeAsString(csv);
      }

       var result = platform.invokeMethod("scanFile",{"path":path});
    }
  }
}