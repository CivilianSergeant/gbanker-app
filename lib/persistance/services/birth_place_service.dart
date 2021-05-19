import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/tables/birth_places_table.dart';
import 'package:gbanker/persistance/entities/BirthPlace.dart';
import 'package:sqflite/sqflite.dart';

class BirthPlaceService{
  static Future<void> seedData() async {
    final Database db = await DbProvider.db.database;
    db.rawInsert("INSERT INTO "+BirthPlacesTable().tableName+" (division_code, district_code, district_name) "
      "VALUES('3', '354', 'Madaripur'),('1', '104', 'Barguna'),('8', '361', 'Mymensingh'),('8', '372', 'Netrakona'),"
      "('3', '382', 'Rajbari'),('2', '275', 'Noakhali'),('2', '230', 'Feni'),('1', '109', 'Bhola'),('2', '212', 'Brahamanbaria'),"
      "('2', '213', 'Chandpur'),('2', '219', 'Cumilla'),('2', '251', 'Lakshmipur'),('3', '367', 'Narayanganj'),"
      "('3', '368', 'Narsingdi'),('8', '339', 'Jamalpur'),('3', '359', 'Munshiganj'),('2', '215', 'Chattogram'),"
      "('3', '356', 'Manikganj'),('3', '326', 'Dhaka'),('1', '106', 'Barishal'),('3', '389', 'Sherpur'),('2', '222', 'Cox''S Bazar'),"
      "('4', '444', 'Jhenaidah'),('4', '457', 'Meherpur'),('4', '450', 'Kushtia'),('3', '386', 'Shariatpur'),('3', '393', 'Tangail'),"
      "('7', '527', 'Dinajpur'),('4', '441', 'Jashore'),('8', '348', 'Kishoreganj'),('7', '532', 'Gaibandha'),('1', '142', 'Jhalokati'),"
      "('1', '178', 'Patuakhali'),('2', '284', 'Rangamati'),('2', '246', 'Khagrachhari'),('3', '335', 'Gopalganj'),('1', '179', 'Pirojpur'),"
      "('2', '203', 'Bandarban'),('3', '333', 'Gazipur'),('3', '329', 'Faridpur'),('4', '455', 'Magura'),('4', '487', 'Satkhira'),"
      "('4', '401', 'Bagerhat'),('7', '549', 'Kurigram'),('4', '465', 'Narail'),('4', '447', 'Khulna'),('5', '581', 'Rajshahi'),"
      "('4', '418', 'Chuadanga'),('5', '564', 'Naogaon'),('5', '510', 'Bogura'),('7', '573', 'Nilphamari'),('7', '552', 'Lalmonirhat'),"
      "('5', '570', 'Nawabganj'),('5', '576', 'Pabna'),('7', '585', 'Rangpur'),('7', '577', 'Panchagarh'),('5', '588', 'Sirajganj'),"
      "('5', '538', 'Joypurhat'),('5', '569', 'Natore'),('6', '691', 'Sylhet'),('6', '658', 'Maulvibazar'),('6', '636', 'Habiganj'),"
      "('6', '690', 'Sunamganj'),('7', '594', 'Thakurgaon'),('1', '31', 'Jhalakati'),('2', '54', 'Brahmanbaria'),('3', '348', 'Kishoreganj'),"
      "('5', '11', 'Chapainawabganj'),('6', '52', 'Moulvibazar'),('8', '37', 'Netrokona'),('8', '389', 'Sherpur');");
//    print("BirthPlace seed done");

  }


  static Future<void> truncateBirthPlaces() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+BirthPlacesTable().tableName);
  }

  static Future<int> addBirthPlace(BirthPlace birthPlace) async{
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(BirthPlacesTable().tableName,
        birthPlace.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<int> addBirthPlaces(List<dynamic> birthPlaces) async {
    int i=0;
    final Database db = await DbProvider.db.database;
    Batch batch = db.batch();
    for(dynamic birthPlace in birthPlaces){
      batch.insert(BirthPlacesTable().tableName,BirthPlace(
        districtCode: birthPlace['DistrictCode'],
        divisionCode: birthPlace['DivisionCode'],
        districtName: birthPlace['DistrictName']
      ).toMap());
      i++;
    }
    await batch.commit(noResult: true);
    return i;
  }

  static Future<List<BirthPlace>> getBirthPlaces({int divisionId}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = List<Map<String,dynamic>>();

    if(divisionId != null && divisionId > 0){
      maps = await db.query(BirthPlacesTable().tableName,where:"division_code=?",
      whereArgs: [divisionId]);
    }else{
      maps = await db.query(BirthPlacesTable().tableName);
    }

    return List.generate(maps.length, (i){
      return BirthPlace(

        divisionCode: maps[i]['division_code'].toString(),
        districtCode: maps[i]['district_code'].toString(),
        districtName: maps[i]['district_name']
      );
    });
  }
}