import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/loan_collection_service.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/withdrawal_service.dart';
import 'package:gbanker/widgets/app_bar.dart';

import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:toast/toast.dart';

class UploadCollectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UploadCollectionScreenState();
}

class UploadCollectionScreenState extends State<UploadCollectionScreen> {
  static const String UPLOAD_COLLECTION_ROUTE = "api/post-mobile-collection";
  List<Map<String,dynamic>> collections = [];
  bool isProcessing = false;

  Widget showButton(){
    if(isProcessing == false){
      if(collections.length>0) {
        return RaisedButton(
          color: ColorList.Colors.primaryBtnColor,
          textColor: Colors.white,
          child: Text("Upload Collection"),
          onPressed: () async {
            uploadData();
          },
        );
      }else{
        return Container();
      }
    }
    return RaisedButton(
      color: ColorList.Colors.primaryBtnColor,
      textColor: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Uploading"),
          SizedBox(
            height: 18.0,
            width: 28.0,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
            ),
          )
        ],
      ),
      onPressed: () async {
        uploadData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(
        title: "Upload Collections", bgColor: ColorList.Colors.primaryColor);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
          backgroundColor: Color(0xffbbdefb),
          key: Key("upload-collection"),
          appBar: appTitleBar.build(context),
          drawer: SafeArea(
            child: NavigationDrawer(),
          ),
          body: showContent()
      ),
    );
  }

  @override
  void initState() {
    loadCollections();
  }

  Widget showContent() {
    if(collections.length>0) {
      return Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 10,
              child: showButton(),
            ),
            Flexible(child: ListView.builder(
              itemCount: collections.length,
              itemBuilder: ((context, i) {
                var collection = collections[i];
                return Container(
                  margin: EdgeInsets.all(2),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Member: ${collection['member_name']}",
                            style: TextStyle(fontWeight: FontWeight.w800,
                                color: Colors.black87),),
                          Text("Amount: ${double.parse(
                              collection['amount'].toString()).toStringAsFixed(
                              0)}"),
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
    }else{
      return Container(
        child: Center(
          child: Text("No data available for sync",style:
            TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),
        ),
      );
    }
  }

  Future<void> loadCollections() async{
    var _collections = await LoanCollectionService.getCollections(isDeletedOnly: false);
    var _withdrawals = await WithdrawalService.getWithdrawals();
//    print(_collections);
//    print(_withdrawals);
    List<Map<String,dynamic>> _list = [];
    _list.addAll(_collections);
    _withdrawals.forEach((w){
      _list.add({
         "member_name": w["member_name"],
         "center_name": w['center_name'],
         "product_name": w['product_name'],
         "amount": w['amount']
       });
    });
    setState(() {
      collections = _list;
    });
  }

  Future<void> uploadData() async {
    setState(() {
      isProcessing = true;
    });

    Setting orgUrlSetting = await SettingService.getSetting('orgUrl');
    bool hasNetwork = await NetworkService.check();
    if(hasNetwork){

      var uploadData = await LoanCollectionService.getUploadedData();

      Map<String,dynamic> map = await NetworkService.post(orgUrlSetting.value+UPLOAD_COLLECTION_ROUTE,uploadData,
          header: {"Content-Type":"application/json"});

        if(map['status']==200){

          await LoanCollectionService.copyUploadedDataToHistory();
          await LoanCollectionService.softDeleteLoanCollection();
          await WithdrawalService.softDeleteWithdrawal();
          //await LoanCollectionService.truncateLoanCollections();

          setState(() {
            isProcessing = false;
            collections = [];
          });

          showSuccessMessage(map['message'], context);

        }
    }else{
      setState(() {
        isProcessing = false;
      });

      showErrorMessage("Internet not available", context);

    }
  }
}
