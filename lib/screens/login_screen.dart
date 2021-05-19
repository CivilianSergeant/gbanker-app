import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/loan_collection_service.dart';
import 'package:gbanker/persistance/services/login_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/widgets/Colors.dart' as prefix0;
import 'package:gbanker/helpers/custom_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{

  final username = TextEditingController();
  final password = TextEditingController();
  static bool fromSplash = false;
  static bool isProcessed = false;
  static bool hasCollection = false;
  static Setting isDownload;
  static Setting isDownloadSaving;
  static bool _obsecureTextFlag = true;
  static String loadedText="";
  static bool isShowSettingUrl = false;
  static bool isShowUpdateAppUrl = false;

  Widget showProgress(){
    if(isProcessed){
      return CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),);
    }else{
      return Text("Login");
    }
  }

  void hasAnyCollection() async{
    var _hasCollection = await LoanCollectionService.hasCollection();
    var _isDownload = await SettingService.getSetting('isDownload');
    var _isDownloadSaving = await SettingService.getSetting('isDownloadSavings');
    setState(() {
      hasCollection = _hasCollection;
      isDownload = _isDownload;
      isDownloadSaving = _isDownloadSaving;
    });
  }

  void hideProgress({bool isSuccess, bool isUpdate, bool isFromSplash}){


    if(isFromSplash != null && isFromSplash == true){
      SettingService.getSetting("fromSplash").then((Setting s){
        if(s != null){
          SettingService.updateSetting({"value":"true"}, "id=?", [s.id]);
          setState(() {
            fromSplash = true;
          });
        }
      });
    }else{
      SettingService.getSetting("fromSplash").then((Setting s){
        if(s != null){
          SettingService.updateSetting({"value":"false"}, "id=?", [s.id]);
          setState(() {
            fromSplash = false;
          });
        }
      });
    }

    setState(() {
      isProcessed=false;

      if(isSuccess!= null && !isSuccess){
        isShowSettingUrl = true;


      }else{



        isShowSettingUrl = false;
        loadedText = "";
      }

      if(isUpdate != null && !isSuccess && isUpdate){

        isShowUpdateAppUrl = true;
        isShowSettingUrl = false;
        loadedText = "";
      }else{

        isShowUpdateAppUrl = false;
        loadedText = "";
      }
    });
  }

  Widget showIfAnyCollectionExist(){

    if(hasCollection && (isDownload !=  null && isDownload.value=="true")){
      return Padding(
        padding: EdgeInsets.only(bottom: 5,left: 20,right: 20),
        child: Text("Warning! Changes you have made will be lost",
          style: TextStyle(color: Colors.red),),
      );
    }else{
      return Text("");
    }

  }

  Widget showCancelButton(BuildContext context){
    if(fromSplash==false && isProcessed == false){
      return InkWell(
        onTap: () async{
          LoginService.setDownloadSettings("isDownload","false");
          LoginService.setDownloadSettings("isDownloadSavings","false");
          Setting s = await SettingService.getSetting("fromSplash");
          SettingService.updateSetting({"value":"false"},"id=?",[s.id]);
          Navigator.of(context).pushReplacementNamed("/home");
        },
        child: Text("Cancel",style: TextStyle(color: Colors.blueAccent),) ,
      );
    }else{
      return Text("");
    }
  }

  void updateLoadedText(String t){
    setState(() {
      loadedText = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: Key("splash"),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xffbbdefb),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:10,bottom: 20),
                child: Image(
                  width: 128,
                  height: 128,
                  image: AssetImage("images/logo.png"),
                ),
              ),
              SizedBox(height: 40,),
              Card(
                elevation: 5,
                borderOnForeground: true,
                child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(

                    children: <Widget>[
                      showIfAnyCollectionExist(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5,left: 20,right: 20),
                        child: SizedBox(
                            width: 250,
                            child: TextField(
                              controller: username,
                              decoration: InputDecoration(
                                  hintText: "Username"
                              ),
                            )
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              width: 250,
                              child: TextField(
                                controller: password,
                                obscureText: _obsecureTextFlag,
                                decoration: InputDecoration(
                                    hintText: "Password"
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child:Container(

                              alignment: Alignment.topRight,
                              child: FlatButton(
                                textColor: Colors.grey,
                                padding: EdgeInsets.only(left: 40),
                                child: Icon(Icons.remove_red_eye),
                                onPressed: (){
                                  setState(() {
                                    _obsecureTextFlag = !_obsecureTextFlag;
                                  });
                                },
                              ),
                            ),
                          )


                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10 ,top: 10),
                        child: SizedBox(width: 250,

                          child: RaisedButton(
                            padding: EdgeInsets.all(5),

                            color: prefix0.Colors.primaryBtnColor,
                            textColor: Colors.white,
                            child: showProgress(),
                            onPressed: (){

                                setState(() {
                                  isProcessed = true;
                                });

                                LoginService.login(context,username.text,
                                    password.text,
                                    callback: this.hideProgress,
                                    updateState: this.updateLoadedText);

                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              //print('${username.text} ${password.text}');
                            },
                          ),
                        ),

                      ),
                      showCancelButton(context),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(loadedText)
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child:  SizedBox(width: 250,
                          child:showSettingUrl(context)
                        ),
                      )
                    ],
                  )
                ),
              )
            ],
          ),
        )

      ),
    );
  }

  Widget showSettingUrl(BuildContext ctx){
//    print("231 ${isShowSettingUrl} ${isShowUpdateAppUrl}");

    if(isShowSettingUrl){
      return Container(
        margin: EdgeInsets.only(top: 5,bottom: 5),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black26,width: 1)
          )
        ),
        child: InkWell(

          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child:Text("Configure App",style: TextStyle(color: Colors.blueAccent),) ,
          ),
          onTap: (){
            Navigator.of(ctx).pushReplacementNamed("/setup");
          },
        ),
      );
    }else if(isShowUpdateAppUrl){
      return Container(
        margin: EdgeInsets.only(top: 5,bottom: 5),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.black26,width: 1)
            )
        ),
        child: InkWell(

          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child:Text("Update App",style: TextStyle(color: Colors.blueAccent),) ,
          ),
          onTap: () async {
            await CustomLauncher.launchURL();
            //Navigator.of(ctx).pushReplacementNamed("/setup");
          },
        ),
      );
    }else{
      return Container();
    }
  }


  Future<void> checkIsFromSplash() async {
    Setting s = await SettingService.getSetting("fromSplash");
    if(s.value == "true"){
      setState(() {
        fromSplash = true;
      });
    }
  }

  @override
  void initState() {
    hideProgress();
    hasAnyCollection();
    checkIsFromSplash();
  }

}