import 'package:gbanker/persistance/tables/IDatabaseDDL.dart';

class SettingsTable implements IDatabaseDDL{
  String _tableName="settings";

  String get tableName {
    return this._tableName;
  }

  @override
  String createDDL() {

    return "CREATE TABLE "+_tableName+" ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "option VARCHAR(30),"
        "value VARCHAR(100)"
        ")";
  }

  @override
  List<String> createIndexes() {
    // TODO: implement createIndexes
    return null;
  }

  @override
  String dropDDL() {
    // TODO: implement dropDDL
    return null;
  }

}