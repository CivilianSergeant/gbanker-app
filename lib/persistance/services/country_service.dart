import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/countries_table.dart';
import 'package:gbanker/persistance/entities/Country.dart';
import 'package:sqflite/sqflite.dart';

class CountryService{
  static Future<void> seedData() async {
    final Database db = await DbProvider.db.database;
    db.rawInsert("INSERT INTO "+CountriesTable().tableName+" (id, country_code, country_name, country_short_code, iso_code_3, status) VALUES"
        "(18, NULL, 'Bangladesh', 'BD', 'BGD', 1);");
//    print('Countries Seed done');
  }

  static Future<void> truncateCountries() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+CountriesTable().tableName);
  }

  static Future<int> addCountry(Country country) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(CountriesTable().tableName, country.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<int> addCountries(List<dynamic> countries) async{
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    for(dynamic country in countries){
      batch.insert(CountriesTable().tableName,Country(
        id: country['CountryId'],
        countryCode: country['CountryCode'],
        countryName: country['CountryName'],
        countryShortCode: country['CountryShortCode'],
        isoCode3: country['isoCode3'],
        status: country['Status']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<Country>> getCountries() async{
    final Database db = await DbProvider.db.database;
    final List<Map<String,dynamic>> maps = await db.query(CountriesTable().tableName);

    return List.generate(maps.length, (i){
      return Country(
        id: maps[i]['id'],
        countryCode: maps[i]['country_code'],
        countryName: maps[i]['country_name'],
        countryShortCode: maps[i]['country_short_code'],
        isoCode3: maps[i]['iso_code_3'],
        status: (maps[i]['status']==1)? true : false
      );
    });
  }
}