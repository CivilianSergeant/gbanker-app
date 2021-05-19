import 'package:flutter/material.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/Member.dart';
import 'package:gbanker/persistance/entities/Product.dart';
import 'package:gbanker/persistance/entities/SavingsAccount.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/member_product_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/product_service.dart';
import 'package:gbanker/persistance/services/savings_account_service.dart';
import 'package:gbanker/widgets/app_bar.dart';

import 'package:gbanker/persistance/entities/Center.dart' as gBanker;
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/group_caption.dart';
import 'package:gbanker/widgets/list_option.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';


class SavingsAccountScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SavingsAccountScreenState();

}

class SavingsAccountScreenState extends State<SavingsAccountScreen>{

  TextEditingController savingsInstallmentController = TextEditingController();

  bool listViewFlag = false;
  List<DropdownMenuItem<int>> centerList = [];
  List<DropdownMenuItem<int>> memberList = [];
  List<DropdownMenuItem<int>> productList = [];
  List<Map<String,dynamic>> accountList = [];
  Product product;


  int _selectedCenter;
  int _selectedMember;
  int _selectedProduct;

  TextEditingController interestRateController = TextEditingController();
  TextEditingController totalAccController = TextEditingController();

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
    if(mounted) {
      setState(() {
        centerList = _collections;
      });
    }
  }

  void loadMembers(int centerId, ) async {
    var members = await MemberService.getMembersByCenter(centerId);

    var _memberCollections = List<DropdownMenuItem<int>>();

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

  void loadProducts () async {
    var _products = await ProductService.getSavingProducts(onlySaving: true);
    var _productList = List<DropdownMenuItem<int>>();

    setState(() {
      _selectedProduct = null;
      productList = [];
    });

    for(dynamic product in _products){
      _productList.add(DropdownMenuItem(
        child: Text("${product['product_code']} - ${product['product_name']}"),
        value: product['product_id'],
      ));
    }

    setState(() {
      if(_productList != null) {
        productList = _productList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var appTitleBar = AppTitleBar(
        title: "Savings Account", bgColor: ColorList.Colors.primaryColor);

    return WillPopScope(
      onWillPop: () async {
        if(listViewFlag==false){
          if(mounted) {
            setState(() {
              listViewFlag = true;
            });
          }
        }else {
          Navigator.pushReplacementNamed(context, "/home");
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("savings-account"),
        appBar: appTitleBar.build(context),
        drawer: SafeArea(
          child: NavigationDrawer(),
        ),
        body: showContent(),
        floatingActionButton: getFloatingButton(),
      ),
    );

  }

  @override
  void initState() {
    loadCenters();
    loadSavingsAccounts();
    if(mounted){
      setState(() {
        listViewFlag = true;
        savingsInstallmentController.text="0.00";
      });
    }
  }

  Widget showContent(){
    return (listViewFlag)? showList() : showCreateFormView();
  }

  Widget getFloatingButton(){
    FloatingActionButton floatingActionButton = null;
    if(this.listViewFlag) {
      floatingActionButton = FloatingActionButton(
        onPressed: () {
          setState(() {
            this.listViewFlag = false;
          });
        },
        child: Icon(Icons.add),
      );
    }
    return floatingActionButton;
  }

  Widget showCreateFormView(){

    return SingleChildScrollView(
      child: Card(
        child: Column(

          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: Text("Add Savings Account",style: TextStyle(
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
              child: GroupCaption(caption: "Select Center",size: 11,)
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
                        _selectedMember = null;
                        loadMembers(_selectedCenter);
                      }
                    });

                  },
                )
            ),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: GroupCaption(caption: "Select Member",size: 11,)
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
                        loadProducts();
                      });
                    }
                )
            ),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: GroupCaption(caption: "Select Product",size: 11,)
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width-20,
              child:DropdownButton(
                items: productList,
                isExpanded: true,
                hint: Text("Products"),
                value: _selectedProduct,
                onChanged: (value) async{
                  product = await ProductService.getProduct(value);
                  var total = await MemberProductService.getNumberOfProducts(_selectedMember, value);
                  setState(() {
                    _selectedProduct = value;
//                    interestRateController.text = interestRate.toString();
                    totalAccController.text = total.toString();
                  });
                }
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: GroupCaption(caption: "Number of Account: " + totalAccController.text ,size: 15,)
            ),
//            SizedBox(
//              width: MediaQuery.of(context).size.width-20,
//              child: TextField(
//                readOnly: true,
//                controller: totalAccController,
//                decoration: InputDecoration(
//                    hintText: "No of Account"
//                ),
//              )),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: GroupCaption(caption: "Savings Installment",size: 11,)
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width-20,
              child: TextField(
                controller: savingsInstallmentController,
                decoration: InputDecoration(

                    hintText: "Savings Installment"
                ),
              )),
            SizedBox(
              width: MediaQuery.of(context).size.width-20,
              child: RaisedButton(
                child: Text('Save Account',style: TextStyle(color: Colors.white),),
                color: Colors.green,
                onPressed: () async {
                  bool inserted = await saveSavingsAccount();
                  if(inserted){
                    showSuccessMessage("Savings Account Created Successfully", context);
                    loadSavingsAccounts();
                    if(mounted) {
                      setState(() {
                        listViewFlag = true;
                      });
                    }
                  }
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width-20,
              child: RaisedButton(
                child: Text("Cancel", style: TextStyle(color: Colors.white),),
                color: Colors.deepOrange,
                onPressed: (){
                  loadSavingsAccounts();
                  setState(() {
                    listViewFlag=true;
                  });
                },
              )
            ),
          ],
        ),
      ),
    );
  }



  Future<bool> saveSavingsAccount() async {
      var savingAccount = SavingsAccount(
        centerId: _selectedCenter,
        memberId: _selectedMember,
        productId: _selectedProduct,
        savingInstallment: double.parse(savingsInstallmentController.text),
        isPostedToLedger: false
      );
      if(savingAccount.savingInstallment < product.minLimit){
        showErrorMessage("Sorry! amount should not be less than "+product.minLimit.toString(), context);
        return false;
      }

      if(savingAccount.savingInstallment> product.maxLimit){
        showErrorMessage("Sorry! amount should not be greater than "+product.maxLimit.toString(), context);
        return false;
      }

      int inserted = await SavingsAccountService.addSavingAccount(savingAccount);
      if(inserted>0){
        reset();
        return true;
      }

      return false;
  }

  void reset(){
    _selectedCenter = null;
    _selectedMember = null;
    _selectedProduct = null;
    memberList = [];
    productList = [];
    savingsInstallmentController.text="0.0";
    totalAccController.text="";
  }

  void loadSavingsAccounts() async{
    var savingsAccounts = await SavingsAccountService.getSavingsAccounts();
    if(mounted) {
      setState(() {
        accountList = savingsAccounts;
      });
    }
  }

  Widget showList(){



    return (accountList.length<=0)? Center(
      child: Text("No Savings Account Exist",

      style: TextStyle(
        color: Colors.blueGrey,
        fontWeight: FontWeight.bold
      ),)
    ) : ListView.builder(
      itemCount: accountList.length,
      itemBuilder: (context,i){
        var account = accountList[i];
        return Card(

          child:
            Padding(
              padding:EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("${account['member_name']}",style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      Text("Savings Installment: ${account['savings_installment']}"),
                      Text("Member Code: ${account['member_code']}"),
                      Text("Samity Code: ${account['center_code']} - ${account['center_name']}"),
                      Text("Product Name:${account['product_code']} - ${account['product_name']}"),

                    ],
                  ),
                  ListOption(
                    index: i,
                    callback: this.handleItemSelect,
                    menus: [
                      {"text":"Post to ledger","icon":Icons.send,"route":"#post"},
                      {"text":"Delete","icon":Icons.delete,"route":"#delete"}
                    ],
                  )
                ],
              )
              ,
          )
        );
      });
  }

  void handleItemSelect(String value) async {
    var account = accountList[int.parse(value.split("#").first)];

    if(value.toString().contains("delete")){
      if(await SavingsAccountService.deleteById(account['id']) > 0){
        setState(() {
          loadSavingsAccounts();
          showSuccessMessage("Saving account deleted", context);
          listViewFlag = true;
          reset();
        });
      }
    }

    if(value.toString().contains("post")){
      if(account['office_id'] == null && account['mid']== null){
        showErrorMessage("Please make sure members available", context);
        return;
      }
      DateTime dt = DateTime.now();
      Map<String,dynamic> obj = {'accounts':[{
        'officeId':account['office_id'],
        'memberId':account['member_id'],
        'productId':account['product_id'],
        'savingsInstallment':account['savings_installment'],
        'createUser':account['created_user'],
        'createDate': dt.toString()
      }]};
      try {
        if(await SavingsAccountService.postToLedger(obj)){
          showSuccessMessage("Account posted to ledger successfully", context);
        }

      } on CustomException catch(ex){
        showErrorMessage(ex.message, context);
      }
    }
  }

}