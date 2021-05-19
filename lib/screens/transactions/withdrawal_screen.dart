import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:gbanker/helpers/adapter/withdrawal_adapter.dart';
import 'package:gbanker/persistance/entities/Center.dart' as gBanker;
import 'package:gbanker/persistance/entities/MemberProduct.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/Withdrawal.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/withdrawal_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class WithdrawalScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => WithdrawalScreenState();

}

class WithdrawalScreenState extends State<WithdrawalScreen>{

  List<DropdownMenuItem<int>> centerList = [];
  List<DropdownMenuItem<int>> memberList = [];
  List<MemberProduct> members = [];
  List<MemberProduct> collections = [];
  int _selectedCenter;
  int _selectedMember;
  int _currentselectedMemberIndex=0;
  static List<WithdrawalAdapter> withdrawals = [];
  static double fontSize;

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(title:"Withdrawal", bgColor: ColorList.Colors.primaryColor);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("withdrawal"),
        appBar: appTitleBar.build(context),
        drawer:SafeArea(
          child: NavigationDrawer(),
        ) ,
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
                        onChanged: (value){
                          setState(() {
                            _selectedCenter=value;
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
                        onChanged: (value){
                          setState(() {
                            _selectedMember=value;
                            for(MemberProduct member in members){
                              if(member.memberId == value){
                                var index = members.indexOf(member);
                                _currentselectedMemberIndex = index;

                                loadCollections(_selectedCenter,_selectedMember);
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
                color: Colors.white,
                child: Container(

                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      SizedBox(
                        height: MediaQuery.of(context).size.height-280,
                        child: ListView.builder(

                          itemBuilder: (context,i){

                            var info = collections[i];


                            var index = i;
                            try {
                              if(withdrawals.length>0) {
                                var l = withdrawals.elementAt(index);

                                if (l != null && l.isChanged == false) {
                                  withdrawals[index].amountController
                                      .text = info.loanRecovery.toStringAsFixed(0);

                                  loadDataToAdapter(index, info);
                                }
                              }

                            }catch(ex){
                              //print("ERROR: "+ex.toString());
                            }
                            return InkWell(
                                onTap: (){
                                  if(withdrawals[index].amountController.text.length>0) {
                                    FocusScope.of(context).requestFocus(
                                        FocusNode());
                                  }
//                                  print(withdrawals[index].amount.toString());
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(bottom: 2,left: 3,right: 3,top: 5),
                                  padding: EdgeInsets.only(top: 5,left: 7,right: 7,bottom: 5),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: (info.productType==1)? Colors.redAccent : Colors.blueAccent,
                                              width: 2
                                          ),bottom: BorderSide(
                                          color: Colors.black12,
                                          width: 0.5
                                      )
                                      )
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Account No: ${info.accountNo}",style: TextStyle(
                                          fontSize: (Device.get().isTablet)? 16:12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54
                                      ),),
                                      SizedBox(height: 5,),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Product: ${info.productName}",style: TextStyle(
                                                fontSize: fontSize,
                                                color: Colors.black
                                            ),),
                                            Text("Installment No: ${info.installmentNo.toString()}",style: TextStyle(
                                                fontSize: fontSize,
                                                color: Colors.black
                                            ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("${(info.productType==1)? 'Recoverable':'Installment'}: "+"${info.recoverable.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.black
                                                )),
                                            Text("${(info.productType==1)? 'Total Balance': 'Sav. Balance'}: ${info.balance.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.black
                                                ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("${(info.productType==1)? 'Prin. Balance':'Deposit'}: ${(info.productType==1)?info.prinBalance.toStringAsFixed(0):info.personalSaving.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.black
                                                )),
                                            Text("${(info.productType==1)?'SC Balance':'Cur. Int.'}: ${info.serBalance.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.black
                                                ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("${(info.productType==1)? 'Due/O.Due':'App. Interest'}: ${info.newDue.toStringAsFixed(0)}",style: TextStyle(
                                                fontSize: fontSize,
                                                color: Colors.black
                                            )),
                                            Text("${(info.productType==1)?'SC Paid':'P. Withdraw'}: ${(info.productType==1)?info.scPaid.toStringAsFixed(0):info.personalWithdraw.toStringAsFixed(0)}",style: TextStyle(
                                                fontSize: fontSize,
                                                color: Colors.black
                                            ))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text("Amount: ",style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.black
                                                )),
                                                SizedBox(
                                                  width: 100,
                                                  height: 30,
                                                  child:TextFormField(
                                                    decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.only(bottom: 5,left: 10),
                                                        border: OutlineInputBorder(
                                                            gapPadding: 0,
                                                            borderSide: BorderSide(color: Colors.black54,width: 1.0,)
                                                        )
                                                    ),
                                                    onTap: (){
                                                      withdrawals[index].amountController.selection = TextSelection(baseOffset: 0,extentOffset: withdrawals[index].amountController.text.length);
                                                    },
                                                    controller: (withdrawals.length>0 && withdrawals[index] != null)?withdrawals[index].amountController : null,
                                                    onChanged: (value){

                                                      if(withdrawals.isNotEmpty && value!=null && value != "") {
                                                        try {


                                                          withdrawals[index].amount = double.parse(value);
                                                          withdrawals[index].isChanged = true;


                                                        }catch(ex){
                                                          //print(ex.getMessage());
                                                        }

                                                      }
                                                    },
                                                  ),),
                                              ],
                                            ),
                                            Text("fine: ${info.fine.toStringAsFixed(0)}",style: TextStyle(
                                                fontSize: fontSize,
                                                color: Colors.black
                                            ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                ));
                          },
                          itemCount: collections.length,

                        ),
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: showButtons(),
      ),
    );
  }

  Widget showButtons(){
    if(MediaQuery.of(context).viewInsets.bottom==0){
      return Container(
        margin: EdgeInsets.only(left: 25,right: 5),

        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            RaisedButton(
              color: ColorList.Colors.primaryBtnColor,
              textColor: Colors.white,
              child: Text("Save"),
              onPressed: (){

                saveWithdrawal();
              },
            ),
            SizedBox(width: 10,),
            RaisedButton(
                color: ColorList.Colors.primaryColor,
                textColor: Colors.white,
                child: Text("Previous"),
                onPressed: (){
                  prevMember();
                }
            ),
            SizedBox(width: 10,),
            RaisedButton(
                color: ColorList.Colors.primaryColor,
                textColor: Colors.white,
                child: Text("Next"),
                onPressed: (){
                  nextMember();
                }
            )
          ],
        ),

      );
    }else{
      return Container();
    }
  }

  @override
  void initState() {
    loadCenters();
    setState(() {
      fontSize = (Device.get().isTablet)? 14:11.5;
    });

  }

  void loadDataToAdapter(int index,MemberProduct info){
    withdrawals[index].officeId = info.officeId;
    withdrawals[index].centerId = info.centerId;
    withdrawals[index].memberId = info.memberId;
    withdrawals[index].orgId = info.orgId;
    withdrawals[index].productId = info.productId;
    withdrawals[index].summaryId = info.summaryId;
    withdrawals[index].dueAmount = info.recoverable;
    withdrawals[index].amount = info.loanRecovery;
    withdrawals[index].loanInstallment = info.loanDue;
    withdrawals[index].intInstallment = info.intDue ;
    withdrawals[index].intCharge = info.intCharge;
    withdrawals[index].trxType = info.trxType;
    withdrawals[index].productType = info.productType;
  }

  Future<void> saveWithdrawal() async {
    Setting _trxDateSetting = await SettingService.getSetting("transactionDate");
    DateTime dateTime = DateTime.parse(_trxDateSetting.value);
    for(WithdrawalAdapter lc in withdrawals){
      var _w = Withdrawal(
          token: Uuid().v1().toString(),
          officeId: lc.officeId,
          centerId: lc.centerId,
          memberId: lc.memberId,
          productId: lc.productId,
          amount: lc.amount,
          dueAmount: lc.dueAmount,
          trxType: lc.trxType,
          productType: lc.productType,
          summaryId: lc.summaryId,
          loanInstallment: lc.loanInstallment,
          intInstallment: lc.amount,
          intCharge: lc.intCharge,
          installmentDate: dateTime.toString().substring(0,19)

      );

      await WithdrawalService.addWithdrawal(_w);
    }
    loadMembers(_selectedCenter);

    Toast.show("Collection saved successfully", context,
        duration: Toast.LENGTH_LONG,gravity: Toast.TOP,
        backgroundColor: Colors.green,textColor:Colors.white);

  }

  void prevMember(){
    if(members.length>0 && _currentselectedMemberIndex>0){
      _currentselectedMemberIndex--;
      setState(() {
        _selectedMember = members[_currentselectedMemberIndex].memberId;
      });
      loadCollections(_selectedCenter,_selectedMember);

    }
  }

  void nextMember(){
    if(members.length>0 && (members.length-1)>_currentselectedMemberIndex){
      _currentselectedMemberIndex++;
      setState(() {
        _selectedMember = members[_currentselectedMemberIndex].memberId;
      });
      loadCollections(_selectedCenter,_selectedMember);
    }
  }


  void loadCenters() async{
    var centers = await CenterService.getCenters();
    var _collections = List<DropdownMenuItem<int>>();
    var i=0;
    for(gBanker.Center center in centers){
      _collections.add(DropdownMenuItem(
        child: Text('${center.centerCode}-${center.centerName}'),
        value: center.id,
      ));
      if(i==0){

        setState(() {
          _selectedCenter = center.id;
          _selectedMember=null;
          memberList = [];

        });

        loadMembers(center.id);
      }
      i++;
    }
    setState(() {
      _currentselectedMemberIndex=0;
      centerList = _collections;
    });

  }

  void loadMembers(int centerId) async{

    members = await MemberService.getMembersByCenter(centerId,isWithdrawal: true);
    withdrawals = [];
    var _memberWithdrawals = List<DropdownMenuItem<int>>();
    var i=0;
    int memberId;
    for(MemberProduct member in members){
      if(i==0){
        memberId = member.memberId;
        loadCollections(_selectedCenter,memberId);
      }
      _memberWithdrawals.add(DropdownMenuItem(
        child: Text('${member.memberName}'),
        value: member.memberId,
      ));

      i++;
    }


    setState(() {
      _currentselectedMemberIndex=0;
      memberList = _memberWithdrawals;
      _selectedMember = memberId;
    });
  }

  void loadCollections(int centerId, int memberId) async{
    setState(() {
      collections=[];
      withdrawals = [];
    });

    var _collections = await MemberService.getMemberCollections(centerId,memberId,onlySavings: true);
    _collections.forEach((c){
      var _withdrawalAdapter = WithdrawalAdapter();


      withdrawals.add(_withdrawalAdapter);
    });
    setState(() {
      collections = _collections;
    });
  }

}