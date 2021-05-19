import 'package:flutter/material.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/Member.dart';
import 'package:gbanker/persistance/entities/MemberProduct.dart';
import 'package:gbanker/persistance/entities/Misc.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/misc_service.dart';
import 'package:gbanker/persistance/services/product_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/persistance/entities/Center.dart' as gBanker;
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/group_caption.dart';
import 'package:gbanker/widgets/list_option.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';

class MiscellaneousEntryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MiscellaneousEntryScreenState();
}

class MiscellaneousEntryScreenState extends State<MiscellaneousEntryScreen>{

  bool listViewFlag = false;

  int _selectedCenter;
  int _selectedMember;
  int _selectedProduct;

  List<DropdownMenuItem<int>> centerList = [];
  List<DropdownMenuItem<int>> memberList = [];
  List<DropdownMenuItem<int>> productList = [];
  List<Map<String,dynamic>> miscs = [];

  bool processing = false;
  bool isDelete = false;
  String processingInfo = "";

  Map<String,dynamic> misc;

  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(
        title: "Miscellaneous Entry", bgColor: ColorList.Colors.primaryColor);

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
      child:Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("misc-entry"),
        appBar: appTitleBar.build(context),
        drawer: SafeArea(
          child: NavigationDrawer(),
        ),
        body: showContent(),
        floatingActionButton: getFloatingButton(),

      )
    );

  }

  Widget getFloatingButton(){
    FloatingActionButton floatingActionButton = null;
    if(this.listViewFlag) {
      floatingActionButton = FloatingActionButton(
        onPressed: () {
          setState((){
            this.listViewFlag = false;
          });
        },
        child: Icon(Icons.add),
      );
    }
    return floatingActionButton;
  }

  Widget showContent(){
    return (listViewFlag)? showList(): showCreateFormView();
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

    for (Member member in members) {
      _memberCollections.add(DropdownMenuItem(
        child: Text('${member.firstName}'),
        value: int.parse(member.memberId),
      ));
    }
    if(mounted) {
      setState(() {
        memberList = _memberCollections;
      });
    }
  }

  void loadProducts() async {
    var products = await ProductService.getMiscProducts();
    var _productList = List<DropdownMenuItem<int>>();
    products.forEach((Map<String,dynamic> map){
      _productList.add(DropdownMenuItem(
        child: Text("${map['product_code']} - ${map['product_name']}"),
        value: map['product_id'],
      ));
    });

    if(mounted) {
      setState(() {
        productList = _productList;
      });
    }
  }

  Widget showCreateFormView(){
    loadCenters();
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Card(
            child: Column(

              children: <Widget>[

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text("Add Miscellaneous",style: TextStyle(
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
                            _selectedProduct=null;
                            loadProducts();
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

                          });
                        }
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select product",size: 11,)
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
                          });
                        }
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Amount",size: 11,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      decoration: InputDecoration(
                          hintText: "Amount"
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Remarks",size: 11,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child: TextField(
                      controller: remarkController,
                      decoration: InputDecoration(
                          hintText: "Remarks"
                      ),
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width-20,
                  child: RaisedButton(
                    child: Text('Save',style: TextStyle(color: Colors.white),),
                    color: Colors.green,
                    onPressed: () async {
                      saveMisc();
                    },
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child: RaisedButton(
                      child: Text("Cancel", style: TextStyle(color: Colors.white),),
                      color: Colors.deepOrange,
                      onPressed: (){
                        setState(() {
                          listViewFlag=true;
                        });
                      },
                    )
                ),
              ],
            ),
          ),
        ),
        showLoader()
      ],
    );
  }

  void saveMisc() async {
    setState(() {
      processing = true;
      processingInfo = "Saving ...";
    });
    Setting guid = await SettingService.getSetting("guid");
    Setting transDate = await SettingService.getSetting("transactionDate");
    User user = await UserService.getUserByGuid(guid.value);
    try {
      await MiscService.addMisc({
        "officeId": user.officeId,
        "centerId": _selectedCenter,
        "productId": _selectedProduct,
        "amount": amountController.text,
        "transDate": transDate.value.toString(),
        "createUser": user.username,
        "memberId": _selectedMember,
        "remarks": remarkController.text
      });
      showSuccessMessage("Miscellaneous entry added successfully",context);
    }on CustomException catch(ex){
      showErrorMessage(ex.message, context);
    }
    loadMiscs();
    setState(() {
      reset();
      listViewFlag = true;
      processing = false;
    });
  }

  Widget showLoader() {
    return (processing || isDelete)? Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:Center(
            child:CustomDialog(showProgress: true,height: (isDelete)? 150 : null,
              progressCallback: (isDelete)? this.showConfirmDeleteDialog : this.downLoadProgressUi,)) ) :
    SizedBox.shrink();
  }

  Widget showConfirmDeleteDialog(){
    return Center(
        child:Padding(
            padding: EdgeInsets.all(0),
            child:Column(
              children: <Widget>[
                SizedBox(height: 20,),
                Text("Are you sure to Delete?",style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color:Colors.red,
                      child: Text("Delete",style: TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: () async {
                        setState(() {
                          processing = true;
                          isDelete = false;
                          processingInfo = "Deleting ...";
                        });

                        Setting transDate = await SettingService.getSetting("transactionDate");
                        Setting guid = await SettingService.getSetting("guid");
                        User user = await UserService.getUserByGuid(guid.value);

                        var postData = {
                          'id':misc['id'],
                          "officeId": misc['office_id'],
                          "centerId":misc['center_id'],
                          "memberId": misc['member_id'],
                          "productId": misc['product_id'],
                          'miscId': misc['misc_id'],
                          "transDate": transDate.value.toString(),
                          'createUser': user.username
                        };

                        try {
                          await MiscService.deleteMisc(postData);
                          showSuccessMessage("Successfully Deleted", context);
                        } on CustomException catch(ex){
                          showErrorMessage(ex.message, context);
                        }

                        loadMiscs();
                        setState(() {
                          isDelete = false;
                          processing = false;
                        });
                      },
                    ),
                    RaisedButton(
                      color:Colors.orange,
                      child: Text("Cancel",style: TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: (){
                        setState(() {
                          isDelete = false;
                          processing = false;
                        });
                      },
                    )
                  ],
                )
              ],
            )
        )
    );
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

  Widget showList(){
    return Stack(
      children: <Widget>[
        (miscs.length<=0)?Center(
      child:Text("No Misc Entry Exist", style: TextStyle(
        color: Colors.blueGrey,
        fontWeight: FontWeight.bold
      ),)
    ):ListView.builder(
        itemCount: miscs.length,
        itemBuilder: (context,i){
          var misc = miscs[i];
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
                      Text("${(misc['member_name']!=null)?misc['member_name']: "N/A"}", style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 2,),
                      Text("Center: ${misc['center_name']}"),
                      SizedBox(height: 2,),
                      Text("Product: ${misc['product_name']}",style: TextStyle(
                        fontSize: (misc['product_name'].length<50)? 14 : 11
                      ),),
                      SizedBox(height: 2,),
                      Text("Amount: ${misc['amount']}"),

                    ],
                  ),
                  ListOption(
                    index: i,
                    callback: this.handleItemSelect,
                    menus: [
                      showDelete(misc)

                    ],
                  )
                ],
              ),
            )
          );
        }),
        showLoader()
    ]);
  }

  dynamic showDelete(dynamic lp){

    return {"text":"Delete", "icon":Icons.delete, "route":"#delete"};

  }

  void handleItemSelect(String value) async {
    var _misc = miscs[int.parse(value
        .split("#")
        .first)];

    if(value.toString().contains("delete")){
      setState(() {
        isDelete = true;
        misc = _misc;
      });
    }
  }

  void loadMiscs() async {
      var _miscs = await MiscService.getMiscs();
//      print(_miscs);
      if(mounted){
        setState(() {
          miscs = _miscs;
        });
      }
  }

  void reset() {
    _selectedProduct = null;
    _selectedMember = null;
    _selectedCenter = null;
    amountController.text = "";
    remarkController.text = "";
  }

  @override
  void initState() {
    loadMiscs();
    if(mounted){
      setState(() {
        listViewFlag = true;
      });
    }
  }

}