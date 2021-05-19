import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/tables/users_table.dart';
import 'package:sqflite/sqlite_api.dart';

class UserService{

  static Future<int> addUser(User user) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(UsersTable().tableName, user.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<void> truncateUsers() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+UsersTable().tableName);
  }

  static Future<User> getUserByUsernamePassword(String username, String password) async {
    User user;
    final Database db = await DbProvider.db.database;
    List<dynamic> whereArgs = [username,password];
    List<Map<String,dynamic>> result = await db.query(UsersTable().tableName,
        where:"username=? AND password=?",
        whereArgs:whereArgs);

    if(result != null && result.length>0) {

      Map<String, dynamic> map = result.first;
      user = User(
          id: map['id'],
          username: map['username'],
          firstname: map['firstname'],
          password:  map['password'],
          guid: map['guid'],
          orgId: map['orgId'],
          officeName: map['officeName'],
          officeId: map['officeId']
      );
    }
    return user;
  }

  static Future<User> getUserByGuid(String guid) async{
    User user;
    final Database db = await DbProvider.db.database;
    List<dynamic> whereArgs = [guid];
    final List<Map<String,dynamic>> maps = await db.query(UsersTable().tableName,
      where:"guid=?",whereArgs: whereArgs,limit: 1);

    maps.forEach((_user){
      user = User(
       id: _user['id'],
       username: _user['username'],
       firstname: _user['firstname'],
       password: _user['password'],
       guid: _user['guid'],
       orgId: _user['orgId'],
       officeId: _user['officeId'],
       officeName: _user['officeName']
      );
    });
    return user;
  }
}