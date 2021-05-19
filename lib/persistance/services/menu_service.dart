import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Menu.dart';
import 'package:gbanker/persistance/tables/menu_permissions_table.dart';
import 'package:gbanker/persistance/tables/menus_table.dart';
import 'package:gbanker/widgets/navigation_drawer/menus.dart';
import 'package:sqflite/sqflite.dart';

class MenuService{

  static Future<void> truncateMenus() async{
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MenusTable().tableName);
  }

  static Future<int> addMenu(List<dynamic> menus)async{
    final Database db = await DbProvider.db.database;
    int i=0;
    for(dynamic menu in menus) {
      try {
        await db.insert(MenusTable().tableName, Menu(
          menuName: menu['menu_name'],
          alias: menu['alias'],
          displayOrder: menu['display_order'],
          groups: menu['groups'],
          isActive: true,
        ).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }on Exception catch(ex){
//        print(ex.toString());
      }
      i++;
    }

    return i;
  }

  static Future<int> addMenus(List<dynamic> menus,{Function uiCallback}) async{
    final Database db = await DbProvider.db.database;
    int i=0;
    Batch batch = db.batch();
    for(dynamic menu in menus){
      var map = Menu(
        //  id: menu['id'],
          menuName: menu['menu_name'],
          alias: menu['alias'],
          groups: menu['groups'],
          displayOrder: menu['display_order'],
          isActive: menu['is_active']

      ).toMap();
//      print(map);
      batch.insert(MenusTable().tableName,map);
      i++;
    }
    try {
      await batch.commit(noResult: true);
    }on Exception catch(ex){
//      print(ex.toString());
    }
    return i;
  }

  static Future<List<Map<String,dynamic>>> getMenus({String group}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> menus = await db.rawQuery("SELECT * FROM menus WHERE groups='${group}'");
    List<Map<String,dynamic>> permittedMenus =[];
    List<Map<String,dynamic>> permissions = await db.query(MenuPermissionsTable().tableName);
    for (var menu in menus) {
      for(var p in permissions){

        if(menu['alias'] == p['alias'] && p['view_permission']==1){
          permittedMenus.add(menu);
        }
      }

    }
    return permittedMenus;
  }
}