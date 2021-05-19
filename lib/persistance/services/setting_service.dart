import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/tables/settings_table.dart';
import 'package:sqflite/sqflite.dart';

class SettingService{

  static Future<int> addSetting(Setting setting) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(SettingsTable().tableName, setting.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<int> updateSetting(Map<String,dynamic> updateValues,String _where,List<dynamic>_whereArgs) async {
    final Database db = await DbProvider.db.database;
    int updated = await db.update(SettingsTable().tableName, updateValues,where:_where,whereArgs: _whereArgs);
    return updated;
  }

  static Future<Setting> getSetting(String option) async {
    Setting setting;
    final Database db = await DbProvider.db.database;
    List<dynamic> whereArgs = [option];
    List<Map<String,dynamic>> result = await db.query(SettingsTable().tableName,
        where:"option=?",
        whereArgs:whereArgs);

    if(result != null && result.length>0) {

      Map<String, dynamic> _settingMap = result.first;
      setting = Setting(
        id: _settingMap['id'],
        option: _settingMap['option'],
        value:  _settingMap['value']
      );
    }
    return setting;
  }


}