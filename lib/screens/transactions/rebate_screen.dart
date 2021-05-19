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
import 'package:gbanker/persistance/services/menu_service.dart';
import 'package:gbanker/persistance/services/rebate_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/group_caption.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';

import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:intl/intl.dart';

class RebateScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RebateScreenState();
}

class _RebateScreenState extends State<RebateScreen>{

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
  Map<String,dynamic> rebate;

  bool processing = false;
  String processingInfo = "Processing ...";

  Setting setting;
  Setting guid;
  User user;

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(
        title: "Rebate", bgColor: ColorList.Colors.primaryColor);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("rebate"),
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
        onlyLoan: true);

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
                    child: Text("Rebate",style: TextStyle(
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
                        "loanSummaryId":_selectedAccount,
                        "officeId":user.officeId,
                      };

                      try {
                        MenuService.getMenus();

//                        print(postData);
                        var _rebate = await RebateService.getCalulation(
                            postData);
                        setState(() {
                          rebate = _rebate;
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


              ],
            ),
          ),
          showLoader()
        ],
      ),
    );
  }

  void reset(){
    setState(() {
      _selectedProduct = null;
      _selectedAccount = null;
      _selectedCenter = null;
      _selectedMember = null;
    });

  }

  Widget showInfo(){
    return (rebate != null)? Container(
      child: Padding(
        padding:EdgeInsets.only(left:5,right: 5),
        child:Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Principal Loan: "),
                Text(rebate['PrincipalLoan'].toString())
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Loan Repaid: "),
                Text("${rebate['LoanRepaid']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Loan Balance: "),
                Text("${rebate['LoanBalance']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("S.Charge: "),
                Text("${rebate['IntCharge']}"),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("SC. Paid"),
                Text("${rebate['IntPaid']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("SC. Balance"),
                Text("${rebate['IntBalance']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("SC Recoverable: "),
                Text("${rebate['CumIntDue']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("New Charge"),
                Text("${rebate['NewRebate']}"),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Rebate: "),
                Text("${rebate['TotalRebate']}")
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("SC. Collection: "),
                Text("${rebate['IntCollection']}")
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("LoanBal + SC. Collection: "),
                Text("${rebate['LoanBalance'] + rebate['IntCollection']}")
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
      reset();
      setState(() {
//        listViewFlag = true;
      });
    }
  }

}