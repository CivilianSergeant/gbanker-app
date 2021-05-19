import 'package:flutter/material.dart';
import 'package:gbanker/config/app_config.dart';
import 'package:gbanker/helpers/file_helper.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/office_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/widgets/Colors.dart' as prefix0;

class SetupScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=> SetupScreenState();
}

class SetupScreenState extends State<SetupScreen>{

  final orgName = new TextEditingController();
  final changeUrl = new TextEditingController();
  final orgUrl = new TextEditingController();
  final port = new TextEditingController();
  static  String orgHintText = "";
  static Color orgHintTextColor = Color(0xffff0000);
  String _selectedDomain;
  List<String> segments;

  @override
  void initState() {
    loadOrgInfo();
    setState(() {
      changeUrl.text = AppConfig.getDefaultUrl(); //"http://gbanker.tech/";
      _selectedDomain = AppConfig.getDefaultDomain();
      port.text = AppConfig.getDefaultPort();
    });

    FileHelper.hasPermission();
  }

  Future<void> loadOrgInfo() async {
    var setting = await SettingService.getSetting('orgUrl');
    var settingName = await SettingService.getSetting('orgName');
    var settingPort = await SettingService.getSetting('orgPort');

    setState(() {
      if(setting != null) {
        orgUrl.text = setting.value;
      }

      if(settingName != null){
        orgName.text = settingName.value;

      }
      if(orgName.text.length ==0){
        orgName.text = AppConfig.getDefaultOrgName();
      }
      if(settingPort != null){
        port.text = settingPort.value;
      }


    });
  }

  List<DropdownMenuItem<String>> getDomain(){
    List<DropdownMenuItem<String>> domains = [];
    domains.add(DropdownMenuItem(child: Text("COM"),value: "com",));
    domains.add(DropdownMenuItem(child: Text("NET"),value: "net",));
    domains.add(DropdownMenuItem(child: Text("ORG"),value: "org",));
    domains.add(DropdownMenuItem(child: Text("TECH"),value: "tech",));
    domains.add(DropdownMenuItem(child: Text("INFO"),value: "info",));
    return domains;
  }

  void updateUrl({String portValue}){
    String url="";
    segments = changeUrl.text.split(".");
    for(int i=0; i<segments.length-1; i++){
      url += segments[i]+".";
    }
    if(portValue != null){
      String _port = (portValue=="80")? "/": ":"+portValue+"/";
      url = url+_selectedDomain+_port;
    }else{
      url = (port.text.length>0)? url+_selectedDomain+
          ':'+port.text+'/' : url+_selectedDomain+":/";
    }

    setState(() {
      changeUrl.text = url;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xffbbdefb),
      body: SingleChildScrollView(

        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50,left: 20),
                child: Text("gBanker App Setup",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: EdgeInsets.only(top:10,left: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-40,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:10,left:20),
                child: Text("Organization Name"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20,bottom: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-40,
                  child: TextField(
                    controller: orgName,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none
                        ,
                      hintText: orgHintText,
                      hintStyle: TextStyle(color: orgHintTextColor)
                    ),
                  ),
                ),
              ),Padding(
                padding: EdgeInsets.only(top:10,left:20),
                child: Text("Organization URL"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20,bottom: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-40,
                  child: TextField(
                    controller: orgUrl,
                    readOnly:true,
                    decoration: InputDecoration(
                        fillColor: Colors.white30,
                        filled: true,
                        border: InputBorder.none

                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:10,left:20),
                child: Text("Change Organization URL"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20,bottom: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-40,
                  child: TextField(
                    controller: changeUrl,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none

                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10,left: 20,bottom: 10),
                            child: Text("Domain"),
                          ),
                          Padding(padding: EdgeInsets.only(left: 20),
                            child: Container(

                              color: Colors.white,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 100,
                                child: DropdownButtonFormField(

                                  items: getDomain(),
                                  value: _selectedDomain,
                                  decoration: InputDecoration(

                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white)
                                    )
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      _selectedDomain = value;
                                    });
                                    updateUrl();
                                  },
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            child: Text("Port"),
                          ),
                          SizedBox(
                            width: 120,
                            child:TextField(
                            controller: port,
                            onChanged: (v){
                              updateUrl(portValue: v);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white
                            ),
                          ))
                        ],
                      ),
                    )

                  ],
                ),
              ),

              Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0,top: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width-40,
                      child: RaisedButton(

                        color: prefix0.Colors.primaryBtnColor,
                        textColor: Colors.white,
                        child: Text("Save Configuration"),
                        onPressed: () async {

                           updateUrl();
                           orgUrl.text = changeUrl.text;


                          if(orgName.text.length == 0){

                            orgHintText = "Organization Name Required";
                            return;
                          }
                          Setting settingName = await SettingService.getSetting('orgName');
                          if(settingName == null){
                            await SettingService.addSetting(Setting(option:"orgName",value: orgName.text));
                          }else{
                            await SettingService.updateSetting({"value":orgName.text}, "id=?", [settingName.id]);
                          }

                           Setting settingPort = await SettingService.getSetting('orgPort');

                            if(settingPort == null){
                             await SettingService.addSetting(Setting(option:"orgPort",value: port.text));
                           }else{
                              await SettingService.updateSetting({"value":port.text}, "id=?", [settingPort.id]);
                           }

                           Setting isDownload = await SettingService.getSetting("isDownload");
                            if(isDownload==null){
                              await SettingService.addSetting(Setting(option: "isDownload",value: "true"));
                            }

                           Setting isDownloadSavings = await SettingService.getSetting("isDownloadSavings");
                           if(isDownloadSavings == null){
                             await SettingService.addSetting(Setting(option: "isDownloadSavings", value: "false"));
                           }

                           Setting settingUrl = await SettingService.getSetting("orgUrl");
                           if(settingUrl == null){
                             await SettingService.addSetting(Setting(option:"orgUrl",value: orgUrl.text));
                             Navigator.of(context).pushReplacementNamed('/login');
                           }else{

                             await SettingService.updateSetting({"value":orgUrl.text}, "id=?", [settingUrl.id]);
                             Setting guidSetting = await SettingService.getSetting('guid');
                             if(guidSetting != null){
                               Navigator.of(context).pushReplacementNamed('/home');
                             }else{
                               Navigator.of(context).pushReplacementNamed('/login');
                             }

                           }


                        },
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),


    );
  }

}