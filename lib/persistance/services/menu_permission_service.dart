import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/MenuPermission.dart';
import 'package:gbanker/persistance/tables/menu_permissions_table.dart';
import 'package:sqflite/sqflite.dart';

class MenuPermissionService{

  static Future<void> truncateMenuPermissinos() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MenuPermissionsTable().tableName);
  }

  static Future<Map<String,dynamic>> getPermission(String permission) async{
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.query(MenuPermissionsTable().tableName,where:"alias=?",whereArgs: [permission]);
    return (maps!= null)? maps.first : null;
  }

  static Future<int> addMenuPermissions(List<dynamic> permissions) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();

    for(dynamic permission in permissions){
      batch.insert(MenuPermissionsTable().tableName,MenuPermission(
          id: permission['id'],
          roleId: permission['RoleId'],
          alias: permission['alias'],
          isActive: permission['isactive'],
          view: permission['view'],
          create: permission['create'],
          delete: permission['delete'],
          approve: permission['approve'],
          disburse: permission['disburse']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }
}