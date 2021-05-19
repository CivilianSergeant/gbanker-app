import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/loan_collection_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:toast/toast.dart';
import 'package:gbanker/persistance/entities/Center.dart' as gBanker;

class CollectionSummaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CollectionSummaryScreenState();
}

class CollectionSummaryScreenState extends State<CollectionSummaryScreen> {
  List<Map<String, dynamic>> list = [];

  List<bool> checkList = [];
  List<Widget> widgetList = [];
  double totalLoan = 0;
  double totalSavings = 0;
  double grandTotal = 0;
  bool showCheckBox = false;
  bool allselected = false;
  List<DropdownMenuItem<int>> centerList = [];
  int _selectedCenter;

  double captionWidth;
  double recoverableWidth;
  double collectionWidth;
  double dueWidth;

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(
        title: "Collection Summary", bgColor: ColorList.Colors.primaryColor);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("collection-summary"),
        appBar: appTitleBar.build(context),
        drawer: SafeArea(
          child: NavigationDrawer(),
        ),
        body: showContent(),

      )
    );
  }

  @override
  void initState() {

    setState(() {
      if(Device.get().isTablet){
//        print('yes');
        captionWidth = 128;
        recoverableWidth = 135;
        collectionWidth = 120;
        dueWidth = 120;
      }else{
//        print('mob');
        captionWidth = 130;
        recoverableWidth = 75;
        collectionWidth = 75;
        dueWidth = 75;
      }
      showCheckBox = false;
    });
    loadCenters().then((_) {
      loadList();
    });
  }

  Widget showContent(){
    if(centerList.length > 0) {
      return Container(
        child: Column(
          children: [
            Card(
                child: DropdownButton(
                  items: centerList,
                  value: _selectedCenter,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedCenter = value;
                      loadList();
                    });
                  },
                )),
            InkWell(
                child: Card(
                  color: Colors.blueAccent,
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      loadCaption(),
                      Container(
                        width: recoverableWidth,
                        decoration: BoxDecoration(color: Colors.blueAccent),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Recoverable",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:12,fontWeight: FontWeight.w800),
                        ),
                        padding: EdgeInsets.only(left:8.0),
                      ),
                      Container(
                        width: collectionWidth,
                        decoration: BoxDecoration(color: Colors.blueAccent),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Collection",
                          style: TextStyle(
                              color: Colors.white,fontSize:12, fontWeight: FontWeight.w800),
                        ),
                        padding: EdgeInsets.only(left:8.0),
                      ),
                      Container(
                        width: dueWidth-7,
                        decoration: BoxDecoration(color: Colors.blueAccent),
                        alignment: Alignment.centerRight ,
                        child: Text(
                          "Due",
                          style: TextStyle(
                              color: Colors.white,fontSize:12, fontWeight: FontWeight.w800),
                        ),
                        padding: EdgeInsets.only(left:8.0,top:8,bottom:8),
                      )
                    ],
                  ),
                )),
            Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: widgetList,
                  ),
                )),
            showFooter()
          ],
        ),
      );
    }else{
      return Center(
        child: Text("No collection found"),
      );
    }
  }

  Future<void> loadCenters() async {
    var centers = await CenterService.getCenters(onlyCollectedCenter: true,isDeleted: false);
    centers.insert(0, gBanker.Center(id: 0, centerName: 'ALL Center',centerCode: 'All'));
    var _collections = List<DropdownMenuItem<int>>();
    var i = 0;
    for (gBanker.Center center in centers) {
      if (i == 0) {
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

  Widget showFooter() {
//    print("HERE ${captionWidth},${recoverableWidth},${collectionWidth},${captionWidth}");
    if (showCheckBox == false) {
      return InkWell(
          child: Container(
        color: Colors.blueAccent,
        margin: EdgeInsets.all(0),
        child: Row(

          children: <Widget>[
            Container(
              width: 130,
              decoration: BoxDecoration(color: Colors.blueAccent),
              alignment: Alignment.centerLeft,
              child: SizedBox(
                  width: captionWidth ,
                  child: Text(
                    "Total",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  )),
              padding: EdgeInsets.only(top:8.0,bottom:8,left:8),
            ),
            Container(
              width: recoverableWidth,
              decoration: BoxDecoration(color: Colors.blueAccent),
              alignment: Alignment.centerRight,
              child: Text(
                totalLoan.toStringAsFixed(0),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
              padding: EdgeInsets.only(top:8.0,bottom:8,left:8),
            ),
            Container(
              width: collectionWidth,
              decoration: BoxDecoration(color: Colors.blueAccent),
              alignment: Alignment.centerRight,
              child: Text(
                totalSavings.toStringAsFixed(0),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
              padding: EdgeInsets.only(top:8.0,bottom:8,left:8),
            ),
            Container(
              width: dueWidth,
              decoration: BoxDecoration(color: Colors.blueAccent),
              alignment: Alignment.centerRight,
              child: Text(
                grandTotal.toStringAsFixed(0),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
              padding: EdgeInsets.only(top:8.0,bottom:8,left:8),
            )
          ],
        ),
      ));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget loadCaption() {
    if (showCheckBox == false) {
      return Container(
        decoration: BoxDecoration(color: Colors.blueAccent),
        alignment: Alignment.center,
        child: SizedBox(
            width: captionWidth-3,
            child: Text(
              "Product",
              style:
                  TextStyle(color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800),
            )),
        padding: EdgeInsets.only(left:8.0),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Colors.blueAccent),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: allselected,
              onChanged: (value) {
                setState(() {
                  allselected = value;
                });
              },
            ),
            SizedBox(
                width: captionWidth,
                child: Text(
                  "Product",
                  style: TextStyle(
                      color: Colors.white, fontSize: 12,fontWeight: FontWeight.w800),
                ))
          ],
        ),
      );
    }
  }

  Widget loadMemberName(map, i) {
    if (showCheckBox == false) {
      return SizedBox(
          width: captionWidth,
          child: Container(
        decoration: BoxDecoration(
          //color: Colors.red,
        ),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: captionWidth,
          child: Text(map["product_name"]),
        ),
        padding: EdgeInsets.only(left: 8.0, right: 8, top: 15, bottom: 18),
      ));
    } else {
      return Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: (checkList[i] == true) ? true : false,
              onChanged: (value) {
                setState(() {
                  checkList[i] = value;
                  loadList(index: i);
                });
              },
            ),
            SizedBox(
              width: captionWidth,
              child: Text(map["product_name"]),
            ),
          ],
        ),
      );
    }
  }

  Future<void> loadList({int index}) async {
//    print("center id:${_selectedCenter}");
    var centerWiseSummary = await LoanCollectionService.getCenterWiseCollections(center_id: _selectedCenter);
    var _list = centerWiseSummary['centerWiseCollections'];
    var _total = centerWiseSummary['centerWiseTotal'];
    //var _list = await LoanCollectionService.getMemberWiseCollectionList(centerId: _selectedCenter);
    setState(() {
      list = _list;
      widgetList = [];
      if (index == null) {
        checkList = [];
      }
      totalSavings = 0;
      totalLoan = 0;
      grandTotal = 0;
      int i = 0;
      int j=0;
      list.forEach((Map<String, dynamic> map) {
        double recoverable = map["recoverable"];
        recoverable = (recoverable != null) ? recoverable : 0;
        double collectionAmount = map["amount"];
        collectionAmount = (collectionAmount != null) ? collectionAmount : 0;
        double dueTotal = map["due"];
        dueTotal = (dueTotal != null) ? dueTotal : 0;

        totalLoan = totalLoan + recoverable;
        totalSavings = totalSavings + collectionAmount;
        grandTotal = grandTotal + dueTotal;
        if (index == null) {
          checkList.add(false);
        }
        if(j==0 && _selectedCenter == 0){
          _total.forEach((f) {
            if(map['center_id']==f['center_id']) {
              widgetList.add(InkWell(

                  child: Card(
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          color: Color(0xff72abea),
                          child:Padding(
                            padding: EdgeInsets.only(left:5,top: 5,bottom: 5),
                            child: Text(f['center_name'],style:
                              TextStyle(color: Colors.white),),
                          ),
                        ),

                      ],
                    ),
                  )));
            }
          });
        }
        widgetList.add(InkWell(

            child: Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  loadMemberName(map, i),
                  Container(
                    color: Colors.white,
                    child: SizedBox(
                      width: recoverableWidth,
                      child: Container(

                        alignment: Alignment.centerRight,
                        child: Text(recoverable.toStringAsFixed(0)),
                        //padding: EdgeInsets.all(8.0),
                      ),
                    ),
                  )
                  ,

              SizedBox(
                width: collectionWidth,
                child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    alignment: Alignment.centerRight,
                    child: Text(collectionAmount.toStringAsFixed(0)),
                    //padding: EdgeInsets.all(8.0),
                  )),
              SizedBox(
                width: dueWidth,
                child:
                Container(
                    decoration: BoxDecoration(color: Colors.white),
                    alignment: Alignment.centerRight,
                    child: Text((dueTotal<0)? 0.toString() : dueTotal.toStringAsFixed(0),
                    style: TextStyle(
                      color: (dueTotal>0)? Colors.red : Colors.black
                    ),
                    ),
                   // padding: EdgeInsets.all(8.0),
                  ))
                ],
              ),
            )));
            j++;
            if(_selectedCenter == 0) {
              _total.forEach((f) {
                if (i == f['index']) {
                  j=0;
                  widgetList.add(Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1,color: ColorList.Colors.primaryColor))
                      ),
                      child: Card(

                        color: Color(0xff72abea),

                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                            //  color: Colors.blueAccent,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: captionWidth-10,
                                child: Text("Total",style: TextStyle(color: Colors.white),),
                              ),
                              padding: EdgeInsets.only(
                                  left: 10, right: 0, top: 8, bottom: 8),
                            ),
                            SizedBox(
                              width: recoverableWidth,
                              child: Container(
                                //color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: Text(f['recoverable'].toStringAsFixed(0),style: TextStyle(color: Colors.white),),
                                padding: EdgeInsets.only(left: 20),
                              ),
                            ),
                        SizedBox(
                          width: collectionWidth,
                          child:Container(
                            //color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: Text(f['total'].toStringAsFixed(0),style: TextStyle(color: Colors.white),),
                              padding: EdgeInsets.only(left: 20),
                            )),
                        SizedBox(
                          width: dueWidth,
                          child:Container(
                            //color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: Text((f['due']<0)?0.toString() : f['due'].toStringAsFixed(0),style: TextStyle(color: Colors.white),),
                              padding: EdgeInsets.only(left: 10),
                            ))
                          ],
                        ),
                      )));
                }
              });
            }
        i++;
      });
    });
  }
}
