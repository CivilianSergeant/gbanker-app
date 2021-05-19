import 'package:flutter/material.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/loan_collection_history_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/group_caption.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/persistance/entities/Center.dart' as gBanker;
import 'package:intl/intl.dart';

class UploadedHistoryScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => UploadedHistoryScreenState();

}

class UploadedHistoryScreenState extends State<UploadedHistoryScreen>{
  List<Map<String,dynamic>> collections = [];
  List<DropdownMenuItem<int>> centerList = [];

  List<DropdownMenuItem<int>> searchTypes = [
    DropdownMenuItem(
      child: Text("By Center And Date"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("By Center"),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text("By Date"),
      value: 2,
    )
  ];

  int _searchType;
  int _selectedCenter;

  TextEditingController searchDateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(title:"Uploaded History", bgColor: ColorList.Colors.primaryColor);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("uploaded-history"),
        appBar: appTitleBar.build(context),
        drawer:SafeArea(
          child: NavigationDrawer(),
        ),
        body: showContent()
      ),
    );
  }

  void loadCenters() async {
    var centers = await CenterService.getUploadedCenters();
    var _collections = List<DropdownMenuItem<int>>();
    var i = 0;
    for (gBanker.Center center in centers) {
      if (i == 0) {
        setState(() {
          _searchType = 0;
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


  @override
  void initState() {
    loadCollections();
    loadCenters();
  }

  Widget showSearchWidget(){

    switch(_searchType){
      case 0:
        return Column(
          children: <Widget>[
            showCenterDropDown(),
            showDateTime()
          ],
        );
        break;
      case 1:
        return showCenterDropDown();
        break;
      case 2:
        return showDateTime();
        break;
    }

    return Container();
  }

  Widget showCenterDropDown(){
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(left: 5,right: 5),
          child: DropdownButton(
            isExpanded: true,
            items: centerList,
            onChanged: (value){
              setState(() {
                _selectedCenter = value;
              });
            },
            value: _selectedCenter,
          ),
        ),
      ),
    );
  }

  Widget showDateTime(){
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 5,right: 5),
        child: TextField(
          controller: searchDateController,
          readOnly: true,
          onTap: (){
            showDatePicker(context: context, initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year-1),
                lastDate: DateTime(DateTime.now().year+1))
                .then((date){
              if(date != null) {
                searchDateController.text =
                    date.toString().substring(0, 11).trim();
              }else{
                searchDateController.text = "";
              }
            });
          },

          decoration: InputDecoration(
              hintText: "Choose Date"
          ),
        ),
      ),
    );
  }

  void searchHistory() async {
    if(_searchType == 0){
      loadCollections(centerId: _selectedCenter,createdDate: searchDateController.text);
    }else if(_searchType == 1){

      loadCollections(centerId: _selectedCenter);
    }else if(_searchType==2){
      loadCollections(createdDate: searchDateController.text);
    }
  }

  Widget showContent() {
    return Container(
      child: Column(
        children: <Widget>[
         Card(
           child: Row(
             children: <Widget>[
               SizedBox(width: 10,),
               GroupCaption(caption: "Search:",size: 16,),
               SizedBox(width: 20,),
               Container(
                 margin: EdgeInsets.only(top:8),
                 width: MediaQuery.of(context).size.width-100,
                 child: DropdownButton(
                   isExpanded: true,
                   items: searchTypes,
                   value: _searchType,
                   onChanged: (value){
                     setState(() {
                       _searchType = value;

                     });
                   },
                 ),
               )
             ],
           ),
         )
          ,
          showSearchWidget(),
          SizedBox(
            width: MediaQuery.of(context).size.width-10,
            child: RaisedButton(
              child: Text("Search",style: TextStyle(color: Colors.white),),
              color: Colors.blueAccent,
              onPressed: () {

                searchHistory();

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
                        Text("Product: ${collection['product_name']}"),
                        Text("Transaction Date: ${DateFormat('d MMM y').format(DateTime.parse(collection['installment_date'].toString().substring(0,10)))}")
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

  Future<void> loadCollections({int centerId, String createdDate}) async{
    var _collections = await LoanCollectionHistoryService.getCollections(
      centerId: centerId,
      createdDate: createdDate
    );
    setState(() {
      collections = _collections;
    });
  }

}