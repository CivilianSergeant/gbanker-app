
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:gbanker/helpers/calculate.dart';
import 'package:gbanker/helpers/adapter/collection_adapter.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/Center.dart' as gBanker;
import 'package:gbanker/persistance/entities/LoanCollection.dart';
import 'package:gbanker/persistance/entities/MemberProduct.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/loan_collection_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/form/list_form.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:gbanker/helpers/csv_writter.dart';

class CollectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CollectionScreenState();
}

class CollectionScreenState extends State<CollectionScreen> {
  List<DropdownMenuItem<int>> centerList = [];
  List<DropdownMenuItem<int>> memberList = [];
  List<MemberProduct> members = [];
  List<MemberProduct> collections = [];
  int _selectedCenter;
  int _selectedMember;
  int _currentselectedMemberIndex = 0;
  static List<CollectionAdapter> loanCollections = [];
  //static double fontSize = 11.5;
  double totalRecoverable = 0;
  double totalCollection = 0;
  TextEditingController searchField = TextEditingController();

  static double fontSize;
  static double ribbonFontSize;
  static String trxDate;

  @override
  Widget build(BuildContext context) {
    String title = (trxDate != null)? "Collection [ ${trxDate} ]" : "Collection";
    var appTitleBar = AppTitleBar(
        title: title, bgColor: ColorList.Colors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async{
              searchField.text="";
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(searchField: searchField,
                    searchMemberCodeCallback: this.searchSubmit,);
                  });
            },
          )
        ]
    );
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("collection"),
        appBar: appTitleBar.build(context),
        drawer: SafeArea(
          child: NavigationDrawer(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  child: (Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton(
                        hint: Text("Select Center"),
                        isExpanded: true,
                        items: centerList,
                        value: _selectedCenter,
                        onChanged: (value) {
                          setState(() {
                            _selectedCenter = value;
                            _selectedMember = null;
                            memberList = [];
                            loadMembers(value);
                          });
                        },
                      ),
                      DropdownButton(
                        hint: Text("Select Member"),
                        isExpanded: true,
                        items: memberList,
                        value: _selectedMember,
                        onChanged: (value) {
                          setState(() {
                            _selectedMember = value;
                            for (MemberProduct member in members) {
                              if (member.memberId == value) {
                                var index = members.indexOf(member);
                                _currentselectedMemberIndex = index;
                             //   print(_currentselectedMemberIndex);
                                loadCollections(_selectedCenter, _selectedMember);
                              }
                            }
                          });
                        },
                      )
                    ],
                  )),
                ),
              ),
              Card(
                color: Color(0xff43a047),
                child:SizedBox(
                  height: 35,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      Text(
                        "Total Recoverable: " ,
                        style: TextStyle(fontWeight: FontWeight.w800,
                        fontSize: ribbonFontSize,
                        color:Colors.white),
                      ),
                      Container(
                          color:Color(0xffffc400),

                          child: SizedBox(
                            height: 40,
                            child: Padding(
                              padding: EdgeInsets.only(top:6,bottom:0.5,left:7,right: 7),
                              child: Text("${totalRecoverable.toStringAsFixed(0)}",
                                style: TextStyle(fontWeight: FontWeight.w800,
                                    color: Colors.black,fontSize:   ribbonFontSize,),
                              ),
                            ),
                          )
                      ),
                      Text( "  Total Collection: ",
                        style: TextStyle(fontWeight: FontWeight.w800,
                            fontSize:ribbonFontSize,
                            color: Colors.white),
                      ),
                      Container(
                        color:Color(0xffffc400),

                        child: SizedBox(
                          height: 40,
                          child: Padding(
                            padding: EdgeInsets.only(top:6,bottom:0.5,left:7,right: 7),
                            child: Text("${totalCollection.toStringAsFixed(0)}",
                              style: TextStyle(fontWeight: FontWeight.w800,
                                  color: Colors.red,fontSize:ribbonFontSize),
                            ),
                          ),
                        )
                      )
                    ],),
                  ),
                ) ,
              )
              ,
              Card(
                color: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[


                      ListForm(
                        collections: collections,
                        adapter: loanCollections,
                        calculateTotal: this.calculateTotal,
                        fontSize: fontSize,
                        dataLoader: CollectionAdapter.loadDataToAdapter,
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top:4),
          child: showButtons(),
        ),
      ),
    );
  }


  void searchSubmit(String memberCode) async {
    bool found = false;
    int i=0;
    members.forEach((MemberProduct m){

      if(m.memberCode.contains(memberCode)){
        found = true;

        loadCollections(_selectedCenter, m.memberId);
        setState(() {
          _selectedMember = m.memberId;
          _currentselectedMemberIndex = i;
        });
        Navigator.of(context).pop();
      }

      i++;
    });

    if(!found){
      Navigator.of(context).pop();
      showErrorMessage("Member Not found with Code [${memberCode}]", context);
    }

  }

  Widget showButtons() {
    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          SizedBox(
            width: (Device.get().isTablet)? 150 : 90,
            child:RaisedButton(
              color: ColorList.Colors.primaryBtnColor,
              textColor: Colors.white,
              child: Text("Save",style: TextStyle(fontSize: (Device.get().isTablet)? 16:12),),
              onPressed: () async {
                // print('here in Save '+CollectionScreenState.loanCollections.length.toString());

                saveMemberCollection();
              },
            )),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: (Device.get().isTablet)? 150 : 90,
              child:RaisedButton(
                color: ColorList.Colors.primaryColor,
                textColor: Colors.white,
                child: Text("Previous",style: TextStyle(fontSize: (Device.get().isTablet)? 16:12),),
                onPressed: () {
                  prevMember();
                })),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: (Device.get().isTablet)? 150 : 90,
              child: RaisedButton(
                  color: ColorList.Colors.primaryColor,
                  textColor: Colors.white,
                  child: Text("Next",style: TextStyle(fontSize: (Device.get().isTablet)? 16:12),),
                  onPressed: () {
                    nextMember();
                  }),
            )

          ],
        ),
      );
    } else {
      return Container();
    }
  }



  Future<void> saveMemberCollection() async {
    List<LoanCollection> _loanCollections = [];

    try {
      Setting _trxDateSetting = await SettingService.getSetting("transactionDate");
      DateTime dateTime = DateTime.parse(_trxDateSetting.value);
      for (CollectionAdapter lcAdapter in loanCollections) {
        double amount = lcAdapter.amount;
        if (lcAdapter.productType == 0) {

          amount = Calculate.savings(lcAdapter.recoverable,
              lcAdapter.amount, lcAdapter.recoverable,
              lcAdapter.orgId,
              int.parse(lcAdapter.productCode.substring(0, 2)));
          lcAdapter.loanInstallment = amount;
        } else if (lcAdapter.productType == 1) {
          var loanInfo = Calculate.loan(
              total: amount,
              duration: lcAdapter.duration,
              intDue: lcAdapter.intDue,
              loanDue: lcAdapter.loanDue,
              principalLoan: lcAdapter.principalLoan,
              loanRepaid: lcAdapter.loanRepaid,
              durationOverLoanDue: lcAdapter.durationOverLoanDue,
              durationOverIntDue: lcAdapter.durationOverIntDue,
              installmentNo: lcAdapter.installmentNo,
              cumInterestPaid: lcAdapter.cumInterestPaid,
              cumIntCharge: lcAdapter.cumIntCharge,
              calcMethod: lcAdapter.interestCalculationMethod,
              doc: lcAdapter.doc,
              orgId: lcAdapter.orgId,
              summaryId: lcAdapter.summaryId,
              vCumLoanDue: lcAdapter.cumLoanDue,
              vCumIntDue: lcAdapter.cumIntDue
          );

          lcAdapter.loanInstallment = loanInfo['loanInstallment'];
          lcAdapter.intInstallment = loanInfo['intInstallment'];
          if(lcAdapter.loanInstallment == 0 && lcAdapter.intInstallment == 0 && lcAdapter.amount > 0){
            return throw CustomException("Please make sure loan amount is correct?",101);
          }
        }

        var _lc = LoanCollection(

          token: Uuid().v1().toString(),
          officeId: lcAdapter.officeId,
          centerId: lcAdapter.centerId,
          memberId: lcAdapter.memberId,
          productId: lcAdapter.productId,
          amount: amount,
          recoverable: lcAdapter.recoverable,
          loanRecovery: lcAdapter.loanRecovery,
          trxType: lcAdapter.trxType,
          productType: lcAdapter.productType,
          summaryId: lcAdapter.summaryId,
          loanInstallment: lcAdapter.loanInstallment,
          intInstallment: lcAdapter.intInstallment,
          intCharge: lcAdapter.intCharge,
          fine: lcAdapter.fine,
          installmentDate: dateTime.toString().substring(0,19),
          createdAt: DateTime.now().toString().substring(0,19)

        );
          

        _loanCollections.add(_lc);
      }



      var setting = await SettingService.getSetting("guid");
      var user = await UserService.getUserByGuid(setting.value);
      await LoanCollectionService.addLoanCollectionBatch(_loanCollections);
      String today = dateTime.day.toString();
     // print('Today ${today}');



      loadMembers(_selectedCenter);

      showSuccessMessage("Collection saved successfully", context);

      await generateCsv(data: await LoanCollectionService.getCollectionsByDate(), filename: user.username+'-'+dateTime.day.toString()+'.csv');

    } on CustomException catch (ex) {

      showErrorMessage((ex.message != null) ? ex.message : ex.toString(), context);

    } on FileSystemException catch(ex){
       showErrorMessage("SD Card not found to save csv", context);
    }
  }



  void prevMember() {
    if (members.length > 0 && _currentselectedMemberIndex > 0) {
      _currentselectedMemberIndex--;
      setState(() {
        _selectedMember = members[_currentselectedMemberIndex].memberId;
      });
      loadCollections(_selectedCenter, _selectedMember);
    }
  }

  void nextMember() {
    if (members.length > 0 &&
        (members.length - 1) > _currentselectedMemberIndex) {
      _currentselectedMemberIndex++;
      setState(() {
        _selectedMember = members[_currentselectedMemberIndex].memberId;
      });
      loadCollections(_selectedCenter, _selectedMember);
    }
  }

  @override
  void initState() {
    loadCenters();
    if(mounted) {
      setState(() {
        fontSize = (Device.get().isTablet)? 14 : 11.5;
        ribbonFontSize = (Device.get().isTablet)? 16 : 11.5;
        totalRecoverable = 0;
        totalCollection = 0;
      });
      loadTrxDate();
      //calculateTotal();
    }

  }

  void loadTrxDate() async{
    Setting setting = await SettingService.getSetting("transactionDate");
    setState(() {
      trxDate = DateFormat('d MMM y').format(DateTime.parse(setting.value));
    });
  }

  void loadCenters() async {
    var centers = await CenterService.getCenters(trxType: 1);
    var _collections = List<DropdownMenuItem<int>>();
    var i = 0;
    for (gBanker.Center center in centers) {
      _collections.add(DropdownMenuItem(
        child: Text('${center.centerCode}-${center.centerName}'),
        value: center.id,
      ));
      if (i == 0) {
        setState(() {
          _selectedCenter = center.id;
          _selectedMember = null;
          memberList = [];
        });
        //print('here before load member');
        loadMembers(center.id);
      }
      i++;
    }
    setState(() {
      _currentselectedMemberIndex = 0;
      centerList = _collections;
    });
  }

  void loadMembers(int centerId, {bool isAfterSuccess}) async {
    members = await MemberService.getMembersByCenter(centerId, trxType: 1);
    loanCollections = [];
    var _memberCollections = List<DropdownMenuItem<int>>();
    var i = 0;
    int memberId;
    for (MemberProduct member in members) {
      if (i == 0) {
        memberId = member.memberId;
        loadCollections(_selectedCenter, memberId);
      }
      _memberCollections.add(DropdownMenuItem(
        child: Text('${member.memberName}'),
        value: member.memberId,
      ));

      i++;
    }

    setState(() {
      //if(isAfterSuccess == null || !isAfterSuccess) {
      _currentselectedMemberIndex = 0;
      //}
      memberList = _memberCollections;
      _selectedMember = memberId;
    });
  }

  void  loadCollections(int centerId, int memberId) async {
    setState(() {
      collections = [];
      loanCollections = [];

      totalCollection = 0;
      totalRecoverable = 0;
    });

    var _collections = await MemberService.getMemberCollections(
        centerId, memberId,
        trxType: 1);
    double _totalRecoverable = 0;
    double _totalCollection = 0;

    _collections.forEach((c) {
      var _collectionAdapter = CollectionAdapter();
      loanCollections.add(_collectionAdapter);

      if(c.productType==1){
        _totalRecoverable = _totalRecoverable + c.recoverable;
      }else{
        _totalRecoverable = _totalRecoverable + c.recoverable;
      }

      _totalCollection = _totalCollection +  c.loanRecovery;;
    });
    setState(() {
      collections = _collections;
      totalRecoverable = _totalRecoverable;
      totalCollection = _totalCollection;
    });
  }

  void calculateTotal() {
    double _totalRecoverable = 0;
    double _totalCollection = 0;
    loanCollections.forEach((f) {
      _totalRecoverable = _totalRecoverable + f.recoverable;
      _totalCollection = _totalCollection + f.amount;
    });
    setState(() {
      totalRecoverable = _totalRecoverable;
      totalCollection = _totalCollection;
    });
  }
}
