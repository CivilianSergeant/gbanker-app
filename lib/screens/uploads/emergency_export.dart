import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ftpclient/ftpclient.dart';
import 'package:gbanker/persistance/services/loan_collection_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:path_provider/path_provider.dart';

class EmergencyExportScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => EmergencyExportScreenState();

}

class EmergencyExportScreenState extends State<EmergencyExportScreen>{

  List<Map<String,dynamic>> collections = [];
  bool isUploading = false;

  Widget showText(){
    if(isUploading==true){
      return Text("Export Collection (Uploading)");
    }else{
      return Text("Export Collection");
    }
  }

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(title:"Emergency Export", bgColor: ColorList.Colors.primaryColor);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
          backgroundColor: Color(0xffbbdefb),
          key: Key("emergency-export"),
          appBar: appTitleBar.build(context),
          drawer:SafeArea(
            child: NavigationDrawer(),
          ) ,
          body:showContent()
      ),
    );
  }


  @override
  void initState() {
    loadCollections();
  }

  Widget showContent() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width-10,
            child: RaisedButton(
              color: ColorList.Colors.primaryBtnColor,
              textColor: Colors.white,
              child: showText(),
              onPressed: () async {
                if(isUploading){
                  return;
                }
                setState(() {
                  isUploading= true;
                });
                DateTime dateTime = DateTime.now();
                var settingOrg = await SettingService.getSetting("orgName");
                var setting = await SettingService.getSetting("guid");
                var user = await UserService.getUserByGuid(setting.value);

                final String dir = (await getExternalStorageDirectory()).path;
                String fileName = "${user.username}-${dateTime.day.toString()}.csv";
                String path = "${dir}/Android/data/gbanker/"+fileName;
//                print(path);
                String remoteFileName = settingOrg.value+"-"+fileName;
//                print(remoteFileName);

                FTPClient ftpClient = new FTPClient('socialbusinesspedia.org',
                    user: "raisuddin@socialbusinesspedia.org", pass: "raisuddin");
                ftpClient.connect();
                ftpClient.uploadFile(new File(path),sRemoteName:remoteFileName, mode: TransferMode.binary);
                ftpClient.disconnect();
                setState(() {
                  isUploading= false;
                });

              },
            ),
          ),
          Flexible(child: ListView.builder(
            itemCount: collections.length,
            itemBuilder: ((context, i) {
              var collection = collections[i];
              return Container(
                margin: EdgeInsets.all(2),
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Member: ${collection['member_name']}",
                          style: TextStyle(fontWeight: FontWeight.w800,
                              color: Colors.black87),),
                        Text("Amount: ${double.parse(collection['amount'].toString()).toStringAsFixed(0)}"),
                        Text("Center: ${collection['center_name']}"),
                        Text("Product: ${collection['product_name']}")
                      ],
                    ),
                  ),
                ),
              );
            }),
          ))
        ],
      ),
    );
  }

  Future<void> loadCollections() async{
    var _collections = await LoanCollectionService.getCollections();
    setState(() {
      isUploading = false;
      collections = _collections;
    });
  }

}

