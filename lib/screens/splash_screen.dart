import 'package:flutter/material.dart';
import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/birth_place_service.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/country_service.dart';
import 'package:gbanker/persistance/services/district_service.dart';
import 'package:gbanker/persistance/services/division_service.dart';
import 'package:gbanker/persistance/services/group_service.dart';
import 'package:gbanker/persistance/services/member_category_service.dart';
import 'package:gbanker/persistance/services/office_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/sub_district_service.dart';
import 'package:gbanker/persistance/services/union_service.dart';
import 'package:gbanker/persistance/services/village_service.dart';
import 'package:sqflite/sqflite.dart';

class SplashScreen extends StatefulWidget{

  @override
  State createState() => SplashScreenState();

}



class SplashScreenState extends State<SplashScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("splash"),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          color: Color(0xffbbdefb),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Image(
                    width: 128,
                    height: 128,
                    image: AssetImage("images/logo.png"),
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 140),
                    child: CircularProgressIndicator()
                ),
              )
            ],
          ),
        )
      )
    );
  }

  Future<void> initDb() async {
    final Database db = await DbProvider.db.database;
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
      Future.delayed(Duration(milliseconds: 1400),(){
        SettingService.getSetting("fromSplash").then((Setting s){
          if(s == null){
            SettingService.addSetting(Setting(
                option: "fromSplash",
                value: "true"
            ));
          }else{
            SettingService.updateSetting({"value":"true"}, "id=?", [s.id]);
          }
        });
        SettingService.getSetting("orgName").then((Setting setting){
          if(setting == null){
            //seedData();
            Navigator.of(context).pushReplacementNamed('/setup');
//            SettingService.addSetting(Setting(
//              option: 'seed',
//              value: true
//            ));
          }else{


            Navigator.of(context).pushReplacementNamed('/login');
          }
        });

      });
    });
    super.initState();
  }
}