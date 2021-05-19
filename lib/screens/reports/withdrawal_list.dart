import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/loan_collection_service.dart';
import 'package:gbanker/persistance/services/withdrawal_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:toast/toast.dart';
import 'package:gbanker/persistance/entities/Center.dart' as gBanker;

class WithdrawalListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => WithdrawalListScreenState();

}

class WithdrawalListScreenState extends State<WithdrawalListScreen>{

  List<Map<String,dynamic>> list=[];

  List<bool> checkList = [];
  List<Widget> widgetList = [];
  double totalLoan = 0;
  double totalSavings = 0;
  double grandTotal = 0;
  bool showCheckBox = false;
  bool allselected = false;
  List<DropdownMenuItem<int>> centerList = [];
  int _selectedCenter;

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(title:"Withdrawal List", bgColor: ColorList.Colors.primaryColor);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("withdrawal-list"),
        appBar: appTitleBar.build(context),
        drawer:SafeArea(
          child: NavigationDrawer(),
        ),
        body: showContent(),
        floatingActionButton: Container(
          child: showDeleteButton(),
        ),

      ),
    );
  }

  Widget showContent() {
    return Container(
      child:
      Column(
        children: [
          Card( child:DropdownButton(
            items: centerList,
            value: _selectedCenter,
            isExpanded: true,
            onChanged: (value){
              setState(() {
                _selectedCenter = value;
                loadList();
              });
            },
          )
          ),
          InkWell(
              onTap: (){

              },
              child:Card(
                color: Colors.blueAccent,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    loadCaption(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent
                      ),
                      alignment: Alignment.center,
                      child:Text("Withdraw Amount",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                      padding: EdgeInsets.all(8.0),
                    ),

                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent
                      ),
                      alignment: Alignment.center,
                      child:Text("Total",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                      padding: EdgeInsets.all(8.0),
                    )
                  ],
                ),
              )
          ),

          Flexible(
              child:SingleChildScrollView(
                child: Column(
                  children: widgetList,
                ),
              )
          ),
          showFooter()
        ],
      ),
    );
  }

  @override
  void initState() {

    setState(() {
      showCheckBox=false;
    });
    loadCenters().then((_){
      loadList();
    });


  }

  Future<void> loadCenters() async {
    var centers = await CenterService.getCenters();
    var _collections = List<DropdownMenuItem<int>>();
    var i=0;
    for(gBanker.Center center in centers){
      if(i==0){
        setState(() {
          _selectedCenter = center.id;

        });

      }
      _collections.add(DropdownMenuItem(
        child: Text('${center.centerCode}-${center.centerName}'),
        value: center.id,
      ));

      i++;
    }
    setState(() {

      centerList = _collections;
    });
  }

  Widget showFooter(){
    if(showCheckBox == false){
      return InkWell(

          child:Card(
            color: Colors.blueAccent,
            margin: EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent
                  ),
                  alignment: Alignment.center,
                  child:SizedBox(width: 120,child: Text("Total",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)),
                  padding: EdgeInsets.all(8.0),
                ),

                Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent
                  ),
                  alignment: Alignment.center,
                  child:Text(totalSavings.toStringAsFixed(0),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                  padding: EdgeInsets.all(8.0),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent
                  ),
                  alignment: Alignment.center,
                  child:Text(grandTotal.toStringAsFixed(0),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                  padding: EdgeInsets.all(8.0),
                )
              ],
            ),
          )
      );
    }else{
      return SizedBox.shrink();
    }
  }

  Widget showDeleteButton(){
    if(showCheckBox==true){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(width: 40,
            child: RaisedButton(
              padding: EdgeInsets.all(0),
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () async  {

                List<int> deleteItems = [];
                for(int i=0; i<checkList.length; i++){
                  if(checkList[i]==true) {
                    Map<String,dynamic> map = list.elementAt(i);
                    deleteItems.add(map["member_id"]);
                  }
                }

                int deleted = await WithdrawalService.deleteWithdrawal(idIn: deleteItems.join(","));
                if(deleted>0){
                  setState(() {
                    showCheckBox=false;

                  });
                  await loadList();

                  Toast.show("Successfully Deleted",context,
                      duration: Toast.LENGTH_LONG,
                      textColor: Colors.white,
                      gravity: Toast.TOP,
                      backgroundColor: Colors.green);

                }

              },
            ),
          ),
          SizedBox(width: 10,),
          SizedBox(width: 60,
            child: RaisedButton(
              padding: EdgeInsets.only(left: 5, right: 5),
              color: Colors.orange,
              child: Text("Cancel",style: TextStyle(color: Colors.white),),
              onPressed: () async {
                setState(() {
                  showCheckBox=false;
                });
                await loadList();
              }
            )
          )
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }

  Widget loadCaption(){

    if( showCheckBox==false) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent
        ),
        alignment: Alignment.center,
        child: SizedBox(width: 120,
            child: Text("Member", style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800),)),
        padding: EdgeInsets.all(8.0),
      );
    }else{
      return Container(
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
            color: Colors.blueAccent
        ),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: allselected,
              onChanged: (value){

                setState(() {
                  allselected = value;

                  int i=0;
                  checkList.forEach((f){
                    checkList[i] = value;
                    i++;
                  });

                  loadList(index: 0);
                });

              },
            ),
            SizedBox(width: 120,
                child: Text("Member", style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800),))
          ],
        ),
      );
    }
  }

  Widget loadMemberName(map,i) {

    if (showCheckBox == false) {
      return Container(

        decoration: BoxDecoration(
          color: Colors.white,

        ),
        alignment: Alignment.center,
        child: SizedBox(width: 120, child: Text(map["member_name"]),),
        padding: EdgeInsets.only(left:8.0,right: 8,top:15,bottom: 18),
      );
    }else{
      return Container(
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
            color:  Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Checkbox(

              value: (checkList[i]==true)? true : false,
              onChanged: (value){
                setState(() {
                  checkList[i] = value;
                  loadList(index: i);
                });
              },
            ),
            SizedBox(width: 120, child: Text(map["member_name"]),),
          ],
        ),
      );
    }
  }


  Future<void> loadList({int index}) async {
    var _list = await WithdrawalService.getMemberWiseWithdrawalList(centerId: _selectedCenter);

    setState(() {

      list = _list;
      widgetList = [];
      if(index == null){
        checkList = [];
      }
      totalSavings = 0;
      totalLoan = 0;
      grandTotal = 0;
      int i=0;
      list.forEach((Map<String,dynamic> map){
        double loan = map["loan"];
        loan = (loan != null)? loan : 0;
        double savings = map["savings"];
        savings = (savings != null)? savings : 0;
        double total = map["total"];
        total = (total != null)? total : 0;

        totalLoan = totalLoan+loan;
        totalSavings = totalSavings + savings;
        grandTotal=grandTotal+total;
        if(index == null) {
          checkList.add(false);
        }
        widgetList.add(
              InkWell(
                  onLongPress: (){
                    setState(() {
                      showCheckBox=true;
                      list=[];

                    });
                    loadList();
                  },
                  child:Card(
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        loadMemberName(map,i),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white
                          ),
                          alignment: Alignment.center,
                          child:Text(savings.toStringAsFixed(0)),
                          padding: EdgeInsets.all(8.0),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white
                          ),
                          alignment: Alignment.center,
                          child:Text(total.toStringAsFixed(0)),
                          padding: EdgeInsets.all(8.0),
                        )
                      ],
                    ),
                  )
              )
             );
        i++;
      });


    });
  }

}