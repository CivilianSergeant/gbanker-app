import 'package:flutter/material.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/Center.dart' as gBanker;
import 'package:gbanker/persistance/entities/Member.dart';
import 'package:gbanker/persistance/entities/MemberProduct.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/investor_service.dart';
import 'package:gbanker/persistance/services/loan_proposal_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/menu_permission_service.dart';
import 'package:gbanker/persistance/services/product_service.dart';
import 'package:gbanker/persistance/services/purpose_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/form/badge.dart';
import 'package:gbanker/widgets/group_caption.dart';
import 'package:gbanker/widgets/list_option.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:intl/intl.dart';

class LoanProposalScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoanProposalScreenState();

}

class LoanProposalScreenState extends State<LoanProposalScreen>{

  bool listViewFlag = false;
  List<DropdownMenuItem<int>> centerList = [];
  List<DropdownMenuItem<int>> memberList = [];
  List<Map<String,dynamic>> loanProposalList = [];
  List<Member> members = [];
  List<dynamic> productInstallments = [];
  dynamic productInstallment;
  Member member;
  Map<String,dynamic> product;
  Map<String,dynamic> loanProposal;
  Map<String,dynamic> permission;
  bool validating = false;
  List<Map<String,dynamic>> products = [];
  String downloadingInfo = "Validating";

  bool isDownloading = false;
  User user;

  List<DropdownMenuItem<String>> frequencyModeList = [
    DropdownMenuItem(
      child: Text("Weekly"),value: "W",
    ),
    DropdownMenuItem(
      child: Text("Monthly"),value: "M",
    ),
    DropdownMenuItem(
      child: Text("Fortnightly"), value: "F",
    )
  ];

  List<DropdownMenuItem<int>> disbursementTypeList = [
    DropdownMenuItem(
      child: Text("Once at a time"),
      value: 1,
    )
  ];

  List<DropdownMenuItem<int>> transTypes = [
    DropdownMenuItem(
      child: Text("Cash"), value: 101,
    ),
    DropdownMenuItem(
      child: Text("Bank"), value: 102,
    )
  ];

  List<DropdownMenuItem<int>> investors = [];

  List<DropdownMenuItem<int>> purposes = [];

  List<DropdownMenuItem<String>> mainProducts = [];
  List<DropdownMenuItem<String>> subProducts = [];
  List<DropdownMenuItem<int>> productInstallmentLists = [];
  List<DropdownMenuItem<int>> productLists = [];


  int _selectedCenter;
  int _selectedMember;
  int _selectedTransType;
  String _selectedFrequencyMode;
  String _selectedMainProduct;
  String _selectedSubMainProduct;
  int _selectedProduct;
  int _selectedDisbursementType;
  int _selectedInvestor;
  int _selectedPurpose;
  int _selectedProuctInstallment;

  TextEditingController loanTermController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController appliedAmountController = TextEditingController();
  TextEditingController loanInstallmentController = TextEditingController();
  TextEditingController scInstallmentController = TextEditingController();
  TextEditingController coApplicantNameController = TextEditingController();
  TextEditingController memberPassBookController = TextEditingController();

  TextEditingController guarantorNameController = TextEditingController();
  TextEditingController guarantorFatherController = TextEditingController();
  TextEditingController guarantorRelationController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController proposalNoController = TextEditingController();

  int memberPassBookRegisterId;
  int dobStartYear;
  int dobEndYear;
  DateTime today;
  DateTime dobInitial;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  bool isDelete = false;



  @override
  void initState() {
    proposalNoController.text="200001";
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

    appliedAmountController.text = "0";

    today = DateTime.now();
    dobStartYear = (today.year-100);
    dobEndYear = (today.year-18);
    dobInitial = DateTime(dobEndYear);

    loadCenters();
    loadInvestors();
    loadLoanProposals();
    if(mounted){
      setState(() {
        listViewFlag = true;
      });

    }
  }

  Future<void> loadMainProducts() async{
    var _mainProducts = await ProductService.getMainProducts(paymentFrequency: _selectedFrequencyMode);
    var _mainProductList = List<DropdownMenuItem<String>>();

    _mainProducts.forEach((mProduct){
      _mainProductList.add(DropdownMenuItem(
        child: Text("${mProduct['main_product_code']} - ${mProduct['main_item_name']}"),
        value: mProduct['main_product_code'],
      ));
    });

    if(mounted){
      setState(() {
        mainProducts = _mainProductList;
      });
    }

  }

  Future<void> loadSubMainProducts() async{
    var _subMainProducts = await ProductService.getSubMainProducts(paymentFrequency: _selectedFrequencyMode,
    mainProductCode: _selectedMainProduct);

    var _subMainProductList = List<DropdownMenuItem<String>>();

    _subMainProducts.forEach((mProduct){
      _subMainProductList.add(DropdownMenuItem(
        child: Text("${mProduct['sub_main_category']}"),
        value: mProduct['sub_main_category'],
      ));
    });

    if(mounted){
      setState(() {
        _selectedSubMainProduct = null;
        _selectedProduct = null;
        subProducts = _subMainProductList;
      });
    }

  }

  Future<void> loadProducts() async{
    products = await ProductService.getProducts(paymentFrequency: _selectedFrequencyMode,
        mainProductCode: _selectedMainProduct,
        subMainCategory: _selectedSubMainProduct);

    var _productList = List<DropdownMenuItem<int>>();
    products.forEach((mProduct){
      _productList.add(DropdownMenuItem(
        child: Text("${mProduct['product_name']}"),
        value: mProduct['id'],
      ));
    });

    if(mounted){
      setState(() {

        _selectedProduct = null;
        productLists = _productList;
      });
    }

  }



  void loadCenters() async {
    var _permission = await MenuPermissionService.getPermission('loan-proposal');
//    print(permission);
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
        permission = _permission;
        centerList = _collections;
      });
    }
  }

  Future<void> loadInvestors() async{
    var _investors = await InvestorService.getInvestors();
    var _investorList = List<DropdownMenuItem<int>>();
    _investors.forEach((investor){
      _investorList.add(DropdownMenuItem(
        child: Text('${investor['investor_code']} - ${investor['investor_name']}',
        style: TextStyle(fontSize: 14),),
        value: investor['id']
      ));
    });
    if(mounted) {
      setState(() {

        investors = _investorList;
        if(_investorList.length>0){
          _selectedInvestor = _investorList.first.value;
        }
      });
    }
  }

  Future<void> loadPurposes() async{
    var _purposes = await PurposeService.getPurposes();
    var _purposeList = List<DropdownMenuItem<int>>();
    _purposes.forEach((purpose){
      _purposeList.add(DropdownMenuItem(
          child: Text('${purpose['purpose_code']} - ${purpose['purpose_name']}'),
          value: purpose['id']
      ));
    });
    if(mounted) {
      setState(() {
        purposes = _purposeList;
      });
    }
  }


  void loadMembers(int centerId, ) async {
    members = await MemberService.getMembersByCenter(centerId);
    if(members.length==0){
      showErrorMessage("No Members downloaded yet please download",context);
      Navigator.of(context).pushReplacementNamed("/members");
    }

    var _memberCollections = List<DropdownMenuItem<int>>();

    for (Member member in members) {
      _memberCollections.add(DropdownMenuItem(
        child: Text('${member.memberCode} - ${member.firstName}'),
        value: int.parse(member.memberId.toString()),
      ));
    }

    setState(() {
      memberList = _memberCollections;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(
        title: "Loan Proposal", bgColor: ColorList.Colors.primaryColor,
      actions: [
        PopupMenuButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.more_vert),
          offset:Offset(0,40),

          itemBuilder: (BuildContext context)=><PopupMenuEntry<int>>[
            PopupMenuItem(
              height: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.cloud_download,color: Colors.black54,),
                  Text(" Download Loan Proposals")
                ],
              ),
              value: 1,
            ),

          ],
          onSelected: (value) async {
//            print("SELECTED : ${value}");
            switch(value){
              case 1:
                setState(() {
                  isDownloading = true;
                });
                _refreshIndicatorKey.currentState?.show();
                break;

            }
          },
        )
      ]
    );

    return WillPopScope(
      onWillPop: () async {
        if(listViewFlag==false){
          if(mounted) {
            setState(() {
              listViewFlag = true;
            });
          }
        } else {
          Navigator.pushReplacementNamed(context, "/home");
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
        key: Key("loan-proposal"),
        appBar: appTitleBar.build(context),
        drawer: SafeArea(
          child: NavigationDrawer(),
        ),
        body: showContent(),
        floatingActionButton: getFloatingButton(),
      ),
    );
  }

  Widget showContent(){
    return (listViewFlag)? showList(): showCreateFormView();
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

    return  Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Card(
            child: Column(

              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text("Add Loan Proposal",style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                    ),),
                  ),
                ),SizedBox(
                  width: MediaQuery.of(context).size.width-20,
                  child: Divider(),
                ),
                showProposalNo(),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select Center",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child:DropdownButton(
                      items: centerList,
                      isExpanded: true,
                      hint: Text("Centers",style: TextStyle(
                        fontSize: 12
                      ),),
                      value: _selectedCenter,
                      onChanged: (value) async{
                        setState(() {
                          _selectedMember = null;
                          _selectedFrequencyMode = null;
                          _selectedMainProduct = null;
                          _selectedSubMainProduct = null;
                          _selectedProduct = null;
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
                    child: GroupCaption(caption: "Select Member",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child:DropdownButton(
                        items: memberList,
                        isExpanded: true,
                        hint: Text("Members",style: TextStyle(
                            fontSize: 12
                        )),
                        value: _selectedMember,
                        onChanged: (value){
                          setState(() {
                            loadPurposes();
                            _selectedMember = value;
                            _selectedFrequencyMode = null;
                            _selectedMainProduct = null;
                            _selectedSubMainProduct = null;
                            _selectedProduct = null;
                            members.forEach((m){
                              if(m.memberId == _selectedMember.toString()){
                                member = m;
                                coApplicantNameController.text = member.coApplicantName;
                                memberPassBookController.text = member.memberPassBookNo.toString();
                                memberPassBookRegisterId = (memberPassBookRegisterId != null)?
                                memberPassBookRegisterId : 0;
                              }
                            });
                          });
                        }
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select Frequency Mode",size: 12,)
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: DropdownButton(
                    items: frequencyModeList,
                    isExpanded: true,
                    hint:Text("Frequency Mode",style: TextStyle(
                        fontSize: 12
                    )),
                    value: _selectedFrequencyMode,
                    onChanged: (value){
                      setState(() {
                        _selectedMainProduct = null;
                        _selectedSubMainProduct = null;
                        _selectedProduct = null;
                        _selectedFrequencyMode = value;

                        loadMainProducts();
                      });
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select Main Product",size: 12,)
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: DropdownButton(
                    items: mainProducts,
                    isExpanded: true,
                    hint:Text("Product Main",style: TextStyle(
                        fontSize: 12
                    )),
                    value: _selectedMainProduct,
                    onChanged: (value){
                      setState(() {
                        _selectedMainProduct = value;
                        handleMainProductSelect();

                      });
                    },
                  ),
                ),
                showSubCategory(),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select Product",size: 12,)
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: DropdownButton(
                    items: productLists,
                    isExpanded: true,
                    hint:Text("Products",style: TextStyle(
                        fontSize: 12
                    )),
                    value: _selectedProduct,
                    onChanged: (value) async {
                      setState(() {
                        validating = true;
                      });
                      setState(() {
                        _selectedProduct = value;
                        downloadingInfo = "Validating ...";
                      });
                      validateTerm();
                      //Future.delayed(Duration(milliseconds: 0),validateTerm);
                    },
                  ),
                ),
                showProductInstallment(),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select Investor",size: 12,)
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: DropdownButton(
                    hint:Text("Investor ID",style: TextStyle(
                        fontSize: 12
                    )),

                    items: investors,
                    value: _selectedInvestor,
                    isExpanded: true,
                    onChanged: (value){
                      setState(() {
                        _selectedInvestor = value;
                      });
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Loan Term",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      readOnly: true,
                      controller: loanTermController,
                      decoration: InputDecoration(

                          hintText: "Loan Term",
                          hintStyle: TextStyle(
                              fontSize: 12
                          )
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select Purpose",size: 12,)
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: DropdownButton(

                    hint:Text("Purpose",style: TextStyle(
                        fontSize: 12
                    )),
                    items: (_selectedProduct != null)?purposes :[],
                    value: _selectedPurpose,
                    isExpanded: true,
                    onChanged: (value){
                      setState(() {
                        _selectedPurpose = value;
                      });
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select Disbursement Type",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child:DropdownButton(
                      hint: Text("Disbursement Type",style: TextStyle(
                          fontSize: 12
                      )),
                      isExpanded: true,
                      items: (_selectedProduct != null)? disbursementTypeList : [],
                      value: _selectedDisbursementType,
                      onChanged: (value){
                        setState(() {
                          _selectedDisbursementType = value;
                        });
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Applied Amount(Principal Loan)",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                    readOnly: (_selectedProduct == null)? true : false,
                    onTap: (){
                      if(appliedAmountController .text.length>0) {
                        appliedAmountController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset:
                            appliedAmountController.text.length);
                      }
                    },
                    controller:appliedAmountController,
                    onChanged: (value){

                      try {
                        if(value.length>0) {
                          handleAppliedAmountChange(value);

                        }else{
                          loanInstallmentController.text = "0";
                          scInstallmentController.text = "0";
                        }
                      } on Exception catch( ex) {
//                        print(ex.toString());
                      }


                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(

                        hintText: "0",
                        hintStyle:  TextStyle(
                            fontSize: 12
                        ),
                    ),
                  )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Duration " + showDurationUnit() ,size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      readOnly: true,
                      controller: durationController,
                      decoration: InputDecoration(
                          hintText: "Duration",
                          hintStyle:  TextStyle(
                              fontSize: 12
                          ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Co Applicant Name ",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      controller: coApplicantNameController,
                      decoration: InputDecoration(
                          hintStyle:  TextStyle(
                            fontSize: 12
                          ),
                          hintText: "Co Applicant Name"
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "MemberPassBookNo "+memberPassBookController.text,size: 14,)
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Loan Installment",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      readOnly: true,
                      controller:loanInstallmentController,
                      decoration: InputDecoration(
                          hintText: "Loan Installment",
                          hintStyle:  TextStyle(
                              fontSize: 12
                          ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "${showScOrInt()} Installment",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      readOnly: true,
                      controller: scInstallmentController,
                      decoration: InputDecoration(
                          hintText: "${showScOrInt()} Installment",
                          hintStyle:  TextStyle(
                              fontSize: 12
                          ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Select Trans Type",size: 12,)
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("Trans Type",style: TextStyle(
                        fontSize: 12
                    ),),
                    items: transTypes,
                    value: _selectedTransType,
                    onChanged: (value){
                      setState(() {
                        _selectedTransType = value;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,top:20),
                    child: Text("Guarantor Info",style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                    ),),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Gurarantor Name",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      controller: guarantorNameController,
                      decoration: InputDecoration(
                          hintText: "Write Guarantor Name Here",
                          hintStyle: TextStyle(
                              fontSize: 12
                          )
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Father Name",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      controller: guarantorFatherController,
                      decoration: InputDecoration(
                          hintText: "Write Guarantor Father Name Here",
                          hintStyle: TextStyle(
                              fontSize: 12
                          )
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Relation",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      controller: guarantorRelationController,
                      decoration: InputDecoration(
                          hintText: "Write Relation With Gurarantor Here",
                          hintStyle: TextStyle(
                              fontSize: 12
                          )
                      ),
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child:TextField(
                    controller: dobController,
                    onTap: (){
                      showDatePicker(context: context, initialDate:dobInitial , firstDate: DateTime(dobStartYear), lastDate: DateTime(dobEndYear))
                          .then((date){
                        if(date != null){
                          dobController.text = (date.toString().substring(0,11).trim());
                          setState(() {
                            dobInitial = DateTime.parse(dobController.text);
                          });
                          getAgeInWords();
                        }else{
                          dobController.text="";
                        }
                      });
                    },

                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: 'Date of Birth',
                        hintStyle: TextStyle(
                            fontSize: 12
                        )
                    ),
                  )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Age",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      controller: ageController,
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: "Age ",
                          hintStyle: TextStyle(
                              fontSize: 12
                          )
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GroupCaption(caption: "Address",size: 12,)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width-25,
                    child: TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                          hintText: "Write Guarantor Address Here",
                          hintStyle: TextStyle(
                              fontSize: 12
                          )
                      ),
                    )),
                showSecurityInfo(),
                SizedBox(
                  width: MediaQuery.of(context).size.width-20,
                  child: RaisedButton(

                    child: Text('Save Proposal',style: TextStyle(color: Colors.white),),
                    color: Colors.green,
                    onPressed: (loanTermController.text == "")? null : handleSavePressed,
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
                        reset();
                        loadLoanProposals();
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

  void handleAppliedAmountChange(dynamic value){
    double appliedAmount = double.parse(value);
    double loanInstallment =0;
    double scInstallment = 0;

    if(user != null && user.orgId != 1) {
      loanInstallment = (product['loan_installment'] * appliedAmount);
      scInstallment = (appliedAmount *
          (product['loan_installment'] + product['interest_installment'])) -
          loanInstallment;
    }else{
      loanInstallment = (productInstallment['LoanInstallment'] * appliedAmount);
      scInstallment = (appliedAmount  * (productInstallment['LoanInstallment'] + productInstallment['InterestInstallment'])) - loanInstallment;

      loanInstallment = loanInstallment / 1000;
      scInstallment = scInstallment / 1000;
    }
    loanInstallmentController.text = loanInstallment.round().toStringAsFixed(0);
    scInstallmentController.text = scInstallment.round().toStringAsFixed(0);
  }

  Future<void> handleMainProductSelect() async {
    if(user != null && user.orgId == 1){
      productLists = [];
      productInstallmentLists = [];
      loadProducts();
    }else{
      subProducts =[];
      productLists = [];
      loadSubMainProducts();
    }
  }

  Widget showSubCategory(){
    if(user !=null && user.orgId != 1){
      return Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: GroupCaption(caption: "Select Sub Main Product",size: 12,)
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width-25,
            child: DropdownButton(
              items: subProducts,
              isExpanded: true,
              hint:Text("Sub Main Product",style: TextStyle(
                  fontSize: 12
              )),
              value: _selectedSubMainProduct,
              onChanged: (value){
                setState(() {
                  _selectedSubMainProduct = value;
                  productLists = [];
                  loadProducts();
                });
              },
            ),
          )
        ],
      );
    }
    return SizedBox.shrink();
  }

  Widget showProductInstallment(){
    if(user !=null && user.orgId == 1){
      return Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: GroupCaption(caption: "Select Product Installment",size: 12,)
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width-25,
            child: DropdownButton(
              items: productInstallmentLists,
              isExpanded: true,
              hint:Text("Product Installment",style: TextStyle(
                  fontSize: 12
              )),
              value: _selectedProuctInstallment,
              onChanged: (value){
                setState(() {
                  _selectedProuctInstallment = value;
                  productInstallments.forEach((pi){

                    if(pi['ProductInstallmentMethodId'] == _selectedProuctInstallment){

                      productInstallment = pi;
                    }
                  });
                  //productLists = [];
                  //loadProducts();
                });
              },
            ),
          )
        ],
      );
    }
    return SizedBox.shrink();
  }

  Widget showProposalNo(){
    if(user != null){
      if(user.orgId == 1){
        return Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: GroupCaption(caption: "Proposal No",size: 12,)
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width-25,
                child: TextField(
                  controller: proposalNoController,
                  decoration: InputDecoration(
                      hintText: "Proposal No ",
                      hintStyle: TextStyle(
                          fontSize: 12
                      )
                  ),
                )),

          ],
        );
      }
    }
    return SizedBox.shrink();
  }

  Widget showSecurityInfo(){

    String _appliedAmount = appliedAmountController.text.toString();
//    print(_appliedAmount);
    double _aA = (_appliedAmount.length>0)? double.parse(_appliedAmount):0;

    return (_aA>50000) ? Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10,top:20),
            child: Text("Security Info",style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w800
            ),),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width-20,
          child: Divider(),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10),
            child: GroupCaption(caption: "Bank Name",size: 12,)
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width-25,
            child: TextField(
              controller: bankNameController,
              decoration: InputDecoration(
                  hintText: "Bank Name",
                  hintStyle: TextStyle(
                      fontSize: 12
                  )
              ),
            )),
        Padding(
            padding: EdgeInsets.only(left: 10),
            child: GroupCaption(caption: "Branch Name",size: 12,)
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width-25,
            child: TextField(
              controller: branchNameController,
              decoration: InputDecoration(
                  hintText: "Branch Name",
                  hintStyle: TextStyle(
                      fontSize: 12
                  )
              ),
            )),
        Padding(
            padding: EdgeInsets.only(left: 10),
            child: GroupCaption(caption: "Cheque No",size: 12,)
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width-25,
            child: TextField(
              controller: chequeNoController,
              decoration: InputDecoration(
                  hintText: "Cheque No",
                  hintStyle: TextStyle(
                      fontSize: 12
                  )
              ),
            ))
      ],
    ) : SizedBox.shrink();
  }

  String getAgeInWords (){
    DateTime _dob = DateTime.parse(dobController.text);
    DateTime _now = DateTime.now();
    int _days = _now.difference(_dob).inDays;
    int _years = 0;
    int _months = 0;
    double days = double.parse(_days.toString());
    int remainDays =0;



    if((days%365) > 0){

      _years = (days/365).round();
      remainDays = (days - (_years * 365)).round();

      if((remainDays%30)>0){
        _months = (remainDays/30).round();
        remainDays = (remainDays - (_months*30)).round();
      }
    }

    String ageInWords = _years.toString()+" years ";
    if(_months>0){
      ageInWords += _months.toString() + " months ";
    }

//    if(days>0){
//      ageInWords += remainDays.toString() + " days";
//    }

    ageController.text = ageInWords;

    return ageInWords;
  }

  Future<void> validateTerm() async {
    Setting guid = await SettingService.getSetting("guid");
    User user = await UserService.getUserByGuid(guid.value);
    for(var p in products)  {
      if(p['id']==_selectedProduct){
        product = p;
        loanTermController.text = p['loan_term'];
        durationController.text = p['duration'].toString();
        //print(member.toMap());

        var postData = {
          "officeId":member.officeId,
          "memberId":member.memberId,
          "mainProductCode": _selectedMainProduct,
          "productId": _selectedProduct,
          "userId": ((user != null && user.orgId != 1)? "" : user.username)
        };

        dynamic result = await LoanProposalService.validateTerm(postData);

          if(result != null && result['result'] != null){
            if(user.orgId == 1) {
              loadProductInstallments(result['productInstallment']);
            }
            if(result['status']=="true") {
              loanTermController.text =
                  result['result']['LoantermUP'].toString();
            }else{
              loanTermController.text = "";
              showErrorMessage(result['result']['ErrorName'], context);
            }
          }else{

            loanTermController.text = "";
            showErrorMessage("This member has previous loan", context);
            _selectedProduct = null;
          }
          setState(() {
            validating = false;
          });

      }
    }
  }

  Future<void> loadProductInstallments(List<dynamic> _productInstallments) async {
    productInstallments = _productInstallments;
    var _productInstallmentList = List<DropdownMenuItem<int>>();
    _productInstallments.forEach((productInstallment){
      _productInstallmentList.add(DropdownMenuItem(
        child: Text("${productInstallment['ProductInstallmentMethodName']}"),
        value: productInstallment['ProductInstallmentMethodId'],
      ));
    });

    setState(() {
      productInstallmentLists = _productInstallmentList;
    });
  }

  Widget showLoader() {
    return (validating || isDownloading || isDelete)? Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:Center(
            child:CustomDialog(showProgress: true, height: (isDelete)? 125: null,
              progressCallback: (!isDelete)? this.downLoadProgressUi : this.showConfirmDeleteDialog,)) ) :
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
                      isDownloading = true;
                      downloadingInfo = "Deleting ...";
                    });

                    Setting guid = await SettingService.getSetting("guid");
                    User user = await UserService.getUserByGuid(guid.value);

                    var postData = {
                      "officeId": loanProposal['office_id'],
                      "memberId": loanProposal['member_id'],
                      "productId": loanProposal['product_id'],
                      'loanSummaryId': loanProposal['loan_summary_id'],
                      'userId': user.username
                    };

                    await LoanProposalService.deleteLoanProposal(postData);
//                    print(postData);
                    loadLoanProposals();
                    setState(() {
                      isDelete = false;
                      isDownloading = false;
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
                    Text(downloadingInfo,style:TextStyle(
                        fontWeight: FontWeight.bold
                    )),
                  ],
                )
            )
        )

    );
  }

  void reset(){
    setState(() {
      _selectedCenter = null;
      _selectedMember = null;
      _selectedFrequencyMode = null;
      _selectedMainProduct = null;
      _selectedSubMainProduct = null;
      loanTermController.text = "";
      _selectedPurpose = null;
      _selectedDisbursementType = null;
      _selectedTransType = null;
      durationController.text="";
      appliedAmountController.text="0.0";
      coApplicantNameController.text="";
      loanInstallmentController.text="";
      scInstallmentController.text="";
      guarantorNameController.text="";
      guarantorFatherController.text="";
      guarantorRelationController.text="";
      ageController.text="";
      dobController.text="";
      addressController.text="";
      bankNameController.text="";
      chequeNoController.text="";
      branchNameController.text="";

    });

  }

  void handleSavePressed(){
    if(guarantorNameController.text.length==0){
      showErrorMessage("Guarantor Name Required", context);
      return;
    }

    if(guarantorFatherController.text.length==0){
      showErrorMessage("Guarantor Father Name Required", context);
      return;
    }

    if(guarantorRelationController.text.length==0){
      showErrorMessage("Guarantor Relation Required", context);
      return;
    }

    if(ageController.text.length==0){
      showErrorMessage("Guarantor Age Required", context);
      return;
    }

    if(addressController.text.length == 0){
      showErrorMessage("Guarantor Address Required", context);
      return;
    }

    String _appliedAmount = appliedAmountController.text.toString();
//    print(_appliedAmount);
    double _aA = double.parse(_appliedAmount);

    if(_aA>50000){

      if(bankNameController.text.length == 0){
        showErrorMessage("Security Bank Name Required", context);
        return;
      }

      if(branchNameController.text.length == 0){
        showErrorMessage("Security Branch Name Required", context);
        return;
      }

      if(chequeNoController.text.length == 0){
        showErrorMessage("Cheque No Required", context);
        return;
      }
    }

    setState(() {
       validating = true;
       downloadingInfo = "Saving...";
    });
    saveLoanProposal().then((_){
      setState(() {
        validating = false;
        downloadingInfo = "";
      });
    });

  }

  Future<void> saveLoanProposal() async {
    Setting guid = await SettingService.getSetting("guid");
    User user = await UserService.getUserByGuid(guid.value);

    var postData = {
        "officeId": member.officeId,
        "centerId": _selectedCenter,
        "memberId": member.memberId,
        "frequency": _selectedFrequencyMode,
        "mainProductCode" : _selectedMainProduct,
        "subMainProductCode": _selectedSubMainProduct,
        "productId": _selectedProduct,
        "investorId": _selectedInvestor,
        "loanTerm": loanTermController.text,
        "purposeId": _selectedPurpose,
        "disbursementType": _selectedDisbursementType,
        "appliedAmount": appliedAmountController.text,
        "duration": durationController.text,
        "coApplicantName": coApplicantNameController.text,
        "memberPassBookNo": memberPassBookRegisterId.toString(),
        "loanInstallment":loanInstallmentController.text,
        "scInstallment": scInstallmentController.text,
        "transType": _selectedTransType,
        "guarantorName": guarantorNameController.text,
        "guarantorFather": guarantorFatherController.text,
        "guarantorRelation": guarantorRelationController.text,
        "dateOfBirth": dobController.text,
        "age": ageController.text,
        "address":addressController.text,
        "sequrityBankName": bankNameController.text,
        "sequrityBranchName": branchNameController.text,
        "sequrityChequeNo": chequeNoController.text,
        "userId": user.username,
        "proposalNo": (user!=null && user.orgId != 1) ? null : proposalNoController.text,
        "productInstallmentMethodId": (user != null && user.orgId != 1)? null: _selectedProuctInstallment,
        "productInstallmentMethodName": (user != null && user.orgId != 1)? null :productInstallment['ProductInstallmentMethodName'],
        "piLoanInstallment": (user != null && user.orgId != 1)? null :productInstallment['LoanInstallment'],
        "piInterestInstallment": (user != null && user.orgId != 1)? null : productInstallment['InterestInstallment'],
        "orgId":user.orgId
    };

//    print(postData);
    try {
      var response = await LoanProposalService.saveLoanProposal(postData);
      setState(() {
        listViewFlag = true;
      });
      reset();
      loadLoanProposals();
    } on CustomException catch(ex){
      showErrorMessage(ex.message, context);
    }

  }

  void loadLoanProposals() async {
    Setting guid = await SettingService.getSetting("guid");
    var _user = await UserService.getUserByGuid(guid.value);
    var loanProposals = await LoanProposalService.getLoanProposals();
    if(mounted) {
      setState(() {
        loanProposalList = loanProposals;
        user = _user;
      });
    }
  }

  Widget showList(){
    //loadLoanProposals();


    return RefreshIndicator(
        key: _refreshIndicatorKey,
        child: Stack(children: <Widget>[
          (loanProposalList.length==0)? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Text("No Loan Proposal Exist",

                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold
                        ),)
                  ),
                  SizedBox(height: 100,),
                  SizedBox(
                      width: MediaQuery.of(context).size.width-100,
                      child: RaisedButton(

                          color: Colors.blue,
                          onPressed: () async {
                            setState(() {
                              isDownloading = true;
                            });
                            _refreshIndicatorKey.currentState?.show();

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.cloud_download,
                                color: Colors.white,),
                              Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child:Text("Download Loan Proposals",style:TextStyle(
                                      color:Colors.white
                                  ),)
                              )
                            ],
                          )
                      )),

                ],
              )
          ) : ListView.builder(
              itemCount: loanProposalList.length,
              itemBuilder: (context,i){
                var lp = loanProposalList[i];
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
                              Text("${lp['member_name']}",style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 05,),
                              Text("Product Name: ${lp['product_name']}"),
                              Text("Product Code: ${lp['product_code']}"),
                              Text("Applied Amount: ${lp['applied_amount']}"),
                              Text("Approved Amount: ${(lp['approved_amount'] != null)? lp['approved_amount'] : "N/A"}"),
                              Text("Loan Installment: ${double.parse(lp['loan_installment'].toString()).round()}"),
                              Text("${showScOrInt()} Installment: ${double.parse(lp['sc_installment'].toString()).round()}"),
                              Text("Member Code: ${lp['member_code']}"),
                              Text("Samity Code: ${lp['center_code']} - ${lp['center_name']}"),
                              showInstammentStartDate(lp),
                              SizedBox(height: 10,),
                              showStatus(lp)
                            ],
                          ),
                          ListOption(
                            index: i,
                            callback: this.handleItemSelect,
                            menus: [
                              showApproveOption(lp)
                              ,
                              showDisburseOption(lp),
                              showDelete(lp)

                            ],
                          )
                        ],
                      )
                      ,
                    )
                );
              }),
          showLoader()
        ],),
        onRefresh: () async {
          setState(() {
            downloadingInfo = "Downloading ...";
            isDownloading = true;
          });
          await getLoanProposalsFromServer();

          return true;
        },
    );
  }

  String showScOrInt(){
    if(user !=null){
      if(user.orgId == 1){
        return "Int";
      }else{
        return "SC";
      }
    }
    return "";
  }

  Widget showInstammentStartDate(dynamic lp){
    if(lp['installment_start_date'] != null){
      return Text("Installment Start Date: ${DateFormat('dd MMM y').format(DateTime.parse(lp['installment_start_date']))}");
    }
    return SizedBox.shrink();
  }

  Widget showStatus(dynamic lp){

    if(lp['is_disbursed']==1){
      return Badge(text:"Disbursed",color: Colors.green,);
    }
    if(lp['is_approved']==1){
      return Badge(text: "Approved",color: Colors.green,);
    }

    return SizedBox.shrink();
  }

  dynamic showApproveOption(dynamic lp){
    if(lp['is_approved']!=1 && permission != null && permission['approve_permission'] == 1){
      return {"text":"Approve","icon":Icons.touch_app,"route":"#approve"};
    }
  }

  dynamic showDisburseOption(dynamic lp){

    if(lp['is_approved'] ==1 && lp['is_disbursed'] == 0 && permission != null && permission['disburse_permission'] == 1){
      return {"text":"Disburse","icon":Icons.payment,"route":"#disburse"};
    }
  }

  dynamic showDelete(dynamic lp){
      if(lp['is_approved'] == 0 && permission != null && permission['delete_permission'] == 1) {
        return {"text": "Reject", "icon": Icons.delete, "route": "#delete"};
      }else{
        return {"text": "Delete", "icon": Icons.delete, "route": "#delete"};
      }
  }

  void handleItemSelect(String value) async {
    var lp = loanProposalList[int.parse(value
        .split("#")
        .first)];

    if (value.toString().contains("approve")) {
      Navigator.of(context).pushReplacementNamed("/loan-proposal-approve",arguments: {
        "proposal":lp,
      });
    }

    if(value.toString().contains("disburse")){
      Navigator.of(context).pushReplacementNamed("/loan-proposal-disburse",arguments: {
        "proposal":lp
      });
    }

    if(value.toString().contains("delete")){
      setState(() {
        isDelete = true;
        loanProposal = lp;
      });
    }
  }

  void getLoanProposalsFromServer() async {
      var result = await LoanProposalService.fetchLoanProposals();
      if(result!= null && result['status']=="true" && result['loanProposals'].length>0){
        List<dynamic> _loanProposals = result['loanProposals'];
        setState(() {
          downloadingInfo ="Copying Loan Info 0/"+ (_loanProposals.length).toString();
        });
        int i=0;
        for(dynamic map in result['loanProposals']){

          //print(map);
          var exist = await LoanProposalService.existLoanProposal(loanSummaryId: map['LoanSummaryId']);
          if(!exist){
            int inserted = await LoanProposalService.saveLoanProposalFromApi(map,orgId:user.orgId);

          }
          i++;
          setState(() {
            downloadingInfo ="Copying Loan Info ${i}/"+ (_loanProposals.length).toString();
          });
        }

        loadLoanProposals();
      }

      setState(() {
        isDownloading = false;
        downloadingInfo = "";
      });
//      print(result);
  }

  String showDurationUnit() {
    if(_selectedFrequencyMode == "W"){
      return "(Weekly)";
    }else if(_selectedFrequencyMode == "M"){
      return "(Monthly)";
    }else{
      return "";
    }
  }

}