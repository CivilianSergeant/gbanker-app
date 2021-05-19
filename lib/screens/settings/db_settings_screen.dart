import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Office.dart';
import 'package:gbanker/persistance/services/birth_place_service.dart';
import 'package:gbanker/persistance/services/country_service.dart';
import 'package:gbanker/persistance/services/district_service.dart';
import 'package:gbanker/persistance/services/division_service.dart';
import 'package:gbanker/persistance/services/group_service.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/member_category_service.dart';
import 'package:gbanker/persistance/services/office_service.dart';
import 'package:gbanker/persistance/services/sub_district_service.dart';
import 'package:gbanker/persistance/services/union_service.dart';
import 'package:gbanker/persistance/services/village_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:sqflite/sqflite.dart';

class DbSettingsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DbSettingsScreenState();
}

class DbSettingsScreenState extends State<DbSettingsScreen>{


  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(bgColor: ColorList.Colors.primaryColor);
    appTitleBar.setTitle("DB Settings Check");
    return Scaffold(
      key: Key("db-settings"),
      appBar: appTitleBar.build(context),
      drawer:SafeArea(
        child: NavigationDrawer(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 10),
                child: RaisedButton(
                  child: Text("Seed Data"),
                  onPressed: (){

                  },
                ),),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: RaisedButton(
                    child: Text("Console Trace"),
                    onPressed: (){
                        OfficeService.getOffices().then((dynamic _offices){
//                            print(_offices);
                            List<Office> officeList = _offices;
                            officeList.forEach((Office office){
//                               print(office.officeName);
                            });
                        });
                    },
                  ),)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initDb() async {
    final Database db = await DbProvider.db.database;
//    print("HERE");
  }

  void seedData(){
    try {
      OfficeService.seedData();
      CenterService.seedData();
      GroupService.seedData();
      MemberCategoryService.seedData();
      CountryService.seedData();
      DivisionService.seedData();
      DistrictService.seedData();
      SubDistrictService.seedData();
      UnionService.seedData();
      VillageService.seedData();
      BirthPlaceService.seedData();
      Navigator.pushReplacementNamed(context, '/home');
    }catch(ex){
//      print (ex.toString());
    }
  }

  @override
  void initState() {
    initDb().then((_){
      Future.delayed(Duration(milliseconds: 1500),(){
        seedData();
      });
    });

    super.initState();
  }


}