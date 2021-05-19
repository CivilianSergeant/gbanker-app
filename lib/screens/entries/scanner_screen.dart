import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gbanker/helpers/custom_launcher.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/circular_button.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
class ScannerScreen extends StatefulWidget{

  @override
  State createState()=> ScannerScreenState();
}

class ScannerScreenState extends State<ScannerScreen>{

  String result = "";

  @override
  Widget build(BuildContext context) {

    var appTitleBar = AppTitleBar(
        title: "QR/BAR Code Scanner", bgColor: ColorList.Colors.primaryColor);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("scanner"),
        appBar: appTitleBar.build(context),
        drawer: SafeArea(
          child: NavigationDrawer(),
        ),
        body: showScanButton(),

      ),
    );

  }

  Widget showScanButton(){
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          CircularButton(callback:(){
//            print('hi');
            scan();
          }),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            child:Card(
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child:Text("Scan Result",style: TextStyle(color:Colors.black54,fontWeight:FontWeight.w800),))),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Padding(child:
                    Text(result,style: TextStyle(color: Colors.black87),)
                      ,padding: EdgeInsets.all(10),
                    ) ,
                  ),
                  Padding(padding:EdgeInsets.all(0),child: showButton(),)
                ],
              )
            ),
          )
        ],
      ),
    );
  }

  Widget showButton(){
    if(result.contains("http")){
      return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(

          width: 70,
          height: 30,
          child:Padding(
            padding: EdgeInsets.only(bottom: 5,right: 5),
            child: RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(2),
              onPressed: (){
                CustomLauncher.launchURL(url: result);
              },
              child: Text("Visit"),
            ),
          ) ,
        ) ,
      );
    }else{
      return SizedBox.shrink();
    }
  }

  _qrCallback(String code){
//    print(code);
    return code;
  }
  Future<void> scan() async {
    try{
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    }on PlatformException catch (ex){
      if(ex.code == BarcodeScanner.CameraAccessDenied){
        setState(() {
          result = "Camera permission was denied";
        });
      }else{
        setState(() {
          result = "Unknown Error: ${ex}";
        });
      }
    }on FormatException {
      setState(() {
        result = "Nothing Scanned. Would you like to try again?";
      });
    }
    //String barCode = await scanner.scan();
   // print(barCode);
  }
}