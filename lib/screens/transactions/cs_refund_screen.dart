import 'package:flutter/material.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/Member.dart';
import 'package:gbanker/persistance/entities/MemberProduct.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/center_service.dart';

import 'package:gbanker/persistance/entities/Center.dart' as gBanker;
import 'package:gbanker/persistance/services/cs_refund_service.dart';
import 'package:gbanker/persistance/services/member_product_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/group_caption.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';

import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:intl/intl.dart';

class CsRefundScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => CsRefundScreenState();
}

class CsRefundScreenState extends State<CsRefundScreen>{

  int _selectedCenter;
  int _selectedMember;
  int _selectedProduct;
  int _selectedAccount;

  List<DropdownMenuItem<int>> centerList = [];
  List<DropdownMenuItem<int>> memberList = [];
  List<DropdownMenuItem<int>> productList = [];

  List<DropdownMenuItem<int>> accountList = [];

  TextEditingController amountController = TextEditingController();
  Map<String,dynamic> postData;
  Map<String,dynamic> calcResult;

  bool processing = false;
  String processingInfo = "Processing ...";

  Setting setting;
  Setting guid;
  User user;

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(
        title: "CS Refund", bgColor: ColorList.Colors.primaryColor);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("misc-entry"),
        appBar: appTitleBar.build(context),
        drawer: SafeArea(
          child: NavigationDrawer(),
        ),
        body: showCreateFormView(),
      ),
    );
  }

  void loadCenters() async {
    var centers = await CenterService.getCenters();
    var _collections = List<DropdownMenuItem<int>>();
    var i = 0;
    for (gBanker.Center center in centers) {
      _collections.add(DropdownMenuItem(
        child: Text('${center.centerCode}-${center.centerName}'),
        value: center.id,
      ));

      i++;
    }
    if(mounted){
      setState(() {
        centerList = _collections;
      });

    }
  }

  void loadMembers(int centerId, ) async {
    var members = await MemberService.getMembersByCenter(centerId);
    //loanCollections = [];
    var _memberCollections = List<DropdownMenuItem<int>>();
//    print(members.length);
    for (Member member in members) {
      _memberCollections.add(DropdownMenuItem(
        child: Text('${member.firstName}'),
        value: int.parse(member.memberId),
      ));
    }
    setState(() {
      memberList = _memberCollections;
    });
  }

  void loadProductByMember() async {
    var products = await MemberProductService.getProductsByMember(memberId: _selectedMember,
        productCodeLike: '23',
        onlySavings: true);

    var _productList = List<DropdownMenuItem<int>>();

    for(Map<String,dynamic> map in products){
      _productList.add(DropdownMenuItem(
        child: Text("${map['product_name']}"),
        value: map['product_id'],
      ));
    }

    if(mounted){
      setState(() {
        productList = _productList;
      });
    }

  }

  void loadAccounts() async {
    var accounts = await MemberProductService.getAccountsByProduct(_selectedMember,_selectedProduct);
    var _accountList = List<DropdownMenuItem<int>>();
    accounts.forEach((account){
      _accountList.add(DropdownMenuItem(
        child: Text("${account['account_no']}"),
        value: account['summary_id'],
      ));
    });

    if(mounted){
      setState(() {
        accountList = _accountList;
      });
    }
  }

  Widget showCreateFormView(){
    loadCenters();
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Card(
            child: Column(

              children: <Widget>[

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text("CS Refund",style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                    ),),
                  ),
                ),SizedBox(
                  width: MediaQuery.of(context).size.width-20,
                  child: Divider(),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Center",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child:DropdownButton(
                      items: centerList,
                      isExpanded: true,
                      hint: Text("Centers/ Samity"),
                      value: _selectedCenter,
                      onChanged: (value) async{
                        setState(() {
                          _selectedCenter = value;
                          if(value != null) {
                            loadMembers(_selectedCenter);
                          }
                        });

                      },
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Member",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child:DropdownButton(
                        items: memberList,
                        isExpanded: true,
                        hint: Text("Members"),
                        value: _selectedMember,
                        onChanged: (value){
                          setState(() {
                            _selectedMember = value;
                            loadProductByMember();
                          });
                        }
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Product",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child:DropdownButton(
                        items: productList,
                        isExpanded: true,
                        hint: Text("Product ID"),
                        value: _selectedProduct,
                        onChanged: (value){
                          setState(() {
                            _selectedProduct = value;
                            loadAccounts();
                          });
                        }
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Account",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child:DropdownButton(
                        items: accountList,
                        isExpanded: true,
                        hint: Text("Select no of Account"),
                        value: _selectedAccount,
                        onChanged: (value){
                          setState(() {
                            _selectedAccount = value;
                          });
                        }
                    )
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width-20,
                  child: RaisedButton(
                    child: Text('Caluclate',style: TextStyle(color: Colors.white),),
                    color: Colors.deepOrange,
                    onPressed: () async {

                      setState(() {
                        processingInfo = "Processing ...";
                        processing = true;
                      });

                      setting = await SettingService.getSetting("transactionDate");
                      guid = await SettingService.getSetting("guid");
                      user = await UserService.getUserByGuid(guid.value);

                      postData = {
                        "summaryId":_selectedAccount,
                        "immatureDate": setting.value,
                        "productId": _selectedProduct,
                        "operationStatus":0,
                        "officeId":user.officeId,
                        "createdUser":user.username
                      };
                      try {
//                        print(postData);
                        var _calcResult = await CsRefundService.getCalulation(
                            postData);
                        setState(() {
                          calcResult = _calcResult;
                        });
                      }on CustomException catch(ex){
                        showErrorMessage(ex.message, context);
                      }
                      setState(() {

                        processing =false;
                      });
                    },
                  ),
                ),
                showInfo(),
                (calcResult != null)?SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child: RaisedButton(
                      child: Text("Save", style: TextStyle(color: Colors.white),),
                      color: Colors.green,
                      onPressed: () async{
                        setState(() {
                          processingInfo = "Saving ...";
                          processing = true;
                        });
                        try {
//                          print(postData);
                          var _calcResult = await CsRefundService.getCalulation(
                              postData);
                          showSuccessMessage("Information Saved Successfully", context);
                          setState(() {
                            calcResult = null;
                          });
                        }on CustomException catch(ex){
                          showErrorMessage(ex.message, context);
                        }
                        setState(() {
                          reset();
                          processing =false;
                        });
                      },
                    )
                ): SizedBox.shrink(),

              ],
            ),
          ),
          showLoader()
        ],
      ),
    );
  }

  void reset(){
    _selectedProduct = null;
    _selectedAccount = null;
    _selectedCenter = null;
    _selectedMember = null;
  }

  Widget showInfo(){
    return (calcResult != null)? Container(
      child: Padding(
        padding:EdgeInsets.only(left:5,right: 5),
        child:Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Calc Interest: "),
                Text(calcResult['Calcnterest'].toString())
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Deposit: "),
                Text("${calcResult['Deposit']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Withdrawal: "),
                Text("${calcResult['WithDrawal']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Interest: "),
                Text("${calcResult['Interest']}"),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Trans Date: "),
                Text("${DateFormat('d MMM y').format(DateTime.parse((calcResult['TransDate'])))}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Interest Rate: "),
                Text("${calcResult['InterestRate']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Withdrawal Rate: "),
                Text("${calcResult['WithdrawalRate']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Opening Date: "),
                Text("${DateFormat("d MMM y").format(DateTime.parse(calcResult['OpeningDate']))}"),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Scheme: "),
                Text("${calcResult['SavingInstallment']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Life: "),
                Text("${calcResult['Duration']}")
              ],
            ),
            SizedBox(height: 10,)

          ],
        )
      ),

    ): SizedBox.shrink();
  }

  Widget showLoader() {
    return (processing)? Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:Center(
            child:CustomDialog(showProgress: true,
              progressCallback: this.downLoadProgressUi,)) ) :
    SizedBox.shrink();
  }

  Widget downLoadProgressUi(){
    return Center(
        child:Padding(
            padding:EdgeInsets.all(0),
            child:Padding(
                padding:EdgeInsets.only(top: 15,left:5,right: 5),
                child:Column(
                  children: <Widget>[
                    Text(processingInfo,style:TextStyle(
                        fontWeight: FontWeight.bold
                    )),
                  ],
                )
            )
        )

    );
  }

  @override
  void initState() {
    if(mounted){
      setState(() {
//        listViewFlag = true;
      });
    }
  }

}