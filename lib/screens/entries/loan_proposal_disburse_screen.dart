import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/Bank.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/bank_service.dart';
import 'package:gbanker/persistance/services/loan_proposal_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/group_caption.dart';
import 'package:intl/intl.dart';

class LoanProposalDisburseScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoanProposalDisburseState();

}

class _LoanProposalDisburseState extends State<LoanProposalDisburseScreen>{

  TextEditingController principalLoan = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController chequeIssueDateController = TextEditingController();

  String loanInstallment="";
  String intInstallment="";
  String processingInfo = "Processing";

  bool processing = false;
  Map<String,dynamic> lp;

  List<DropdownMenuItem<String>> bankList = [];
  String _selectedBank=null;
  User user;

  @override
  void initState() {
      loadBank();
  }

  loadBank() async{
    List<Bank> banks = await BankService.getBanks();
    Setting settingGuid = await SettingService.getSetting("guid");
    var _user = await UserService.getUserByGuid(settingGuid.value);
    List<DropdownMenuItem<String>> _bankList = [];
    banks.forEach((bank){
//      print(bank.toMap().toString());
      _bankList.add(DropdownMenuItem(
        child: Text(bank.bankCode + " "+bank.bankName),
        value: bank.bankCode,
      ));
    });
    if(mounted){
      setState(() {
        bankList = _bankList;
        user = _user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(
        title: "Loan Proposal Disburse", bgColor: ColorList.Colors.primaryColor,
        leadingWidget: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed("/loan-proposal");
          },
        )
    );
    return WillPopScope(
        onWillPop: () async{
          Navigator.of(context).pushReplacementNamed("/loan-proposal");
          return false;
        },
        child: Scaffold(
          appBar: appTitleBar.build(context),
          body: SingleChildScrollView(
              child:Stack(
                children: <Widget>[
                  Container(
                      child:Card(

                        child: Padding(
                            padding: EdgeInsets.only(left: 5,right: 5),
                            child: Column(
                              children: <Widget>[
                                showProposalNo(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Member:",size:14),
                                    GroupCaption(caption: lp["member_name"],size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Center:",size:14),
                                    GroupCaption(caption: lp["center_name"],size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Product:",size:14),
                                    GroupCaption(caption: lp['product_code']+" "+lp["product_name"],size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Duration:",size:14),
                                    GroupCaption(caption: lp["duration"].toString(),size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Investor:",size:14),
                                    GroupCaption(caption: lp['investor_code']+"-"+lp["investor_name"],size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Purpose:",size:14),
                                    GroupCaption(caption: lp["purpose_code"]+" "+lp['purpose_name'],size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Co Applicant Name:",size:14),
                                    GroupCaption(caption: lp["co_applicant_name"],size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Guarantor Name:",size:14),
                                    GroupCaption(caption: (lp["guarantor_name"] !=null)? lp["guarantor_name"]: "N/A",size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Disbursement Type:",size:14),
                                    GroupCaption(caption: getDisburseType(lp["disbursement_type_id"]),size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Trans Type:",size:14),
                                    GroupCaption(caption: getTransType(lp["trans_type_id"]),size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Applied Amount:",size:14),
                                    GroupCaption(caption: showAppliedAmount(lp),size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Approve Amount:",size:14),
                                    GroupCaption(caption: showApprovedAmount(lp),size: 14,)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Loan Installment:",size:14),
                                    GroupCaption(caption: ((loanInstallment.length>0)? loanInstallment : showLoanInstallment(lp)),size:14)
                                  ],),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"${showScOrInt()} Installment:",size:14),
                                    GroupCaption(caption: ((intInstallment.length>0)?intInstallment: showIntInstallment(lp)),size:14)
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Installment Start Date:",size:14),
                                    GroupCaption(caption: showInstallmentStartDate(lp),size:14)
                                  ],),
                                Divider(),
                                (lp['trans_type_id'] == 102)?Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Bank",size:14),
                                    DropdownButton(
                                      items: bankList,
                                      value: _selectedBank,
                                      hint: Text("Select Bank"),
                                      onChanged: (value){
                                        setState(() {
                                          _selectedBank = value;
                                        });
                                      },
                                    )
                                  ],):SizedBox.shrink(),
                                (lp['trans_type_id'] == 102)? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Cheque No:",size:14),
                                    SizedBox(
                                      width: 150,
                                      child: TextField(
                                        textAlign: TextAlign.right,
                                        keyboardType: TextInputType.number,
                                        controller: chequeNoController,
                                        decoration: InputDecoration(
                                            hintText: "Cheque No"
                                        ),
                                      ),
                                    )
                                  ],): SizedBox.shrink(),
                                (lp['trans_type_id'] == 102)? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GroupCaption(caption:"Cheque Issue Date: ",size:14),
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width-150,
                                        child:TextField(
                                          textAlign: TextAlign.right,
                                          controller: chequeIssueDateController,
                                          onTap: (){
                                            showDatePicker(context: context,initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year-1), lastDate: DateTime.now())
                                                .then((date){
                                              if(date != null){
                                                chequeIssueDateController.text = (date.toString().substring(0,11).trim());
//                                                setState(() {
//                                                  dobInitial = DateTime.parse(dobController.text);
//                                                });
//                                                getAgeInWords();
                                              }else{
                                                chequeIssueDateController.text="";
                                              }
                                            });
                                          },

                                          readOnly: true,
                                          decoration: InputDecoration(
                                              hintText: 'Cheque Issue Date',
                                              hintStyle: TextStyle(
                                                  fontSize: 12
                                              )
                                          ),
                                        )
                                    ),
                                  ],
                                ):SizedBox.shrink(),
                                SizedBox(height: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Colors.green,
                                      child: Text("Disburse",style: TextStyle(
                                          color: Colors.white
                                      ),),
                                      onPressed: () async {

                                        setState(() {
                                          processing = true;
                                        });
                                        await handleDisburse();
                                        setState(() {
                                          processing = false;
                                        });
                                      },
                                    )
                                  ],),

                              ],
                            )
                        ),
                      )
                  ),
                  showLoader()
                ],
              )),
        ));
  }

  Widget showProposalNo(){
    if(user != null && user.orgId == 1){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GroupCaption(caption:"Proposal No:",size:14),
          GroupCaption(caption: lp["proposal_no"],size:14)
        ],);
    }
    return SizedBox.shrink();
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

  Future<void> handleDisburse() async {

    Setting settingGuid = await SettingService.getSetting("guid");
    var user = await UserService.getUserByGuid(settingGuid.value);
    var postData = {
      "id": lp['id'],
      "officeId": user.officeId,
      "memberId": lp["mid"],
      "productId": lp['product_id'],
      "bankName": _selectedBank,
      "chequeNo": chequeNoController.text,
      "chequeIssueDate": chequeIssueDateController.text,
      "userId": user.username
    };

    if(lp['trans_type_id'] == 102){
      if(_selectedBank == null){
        showErrorMessage("Please Select Bank", context);
        return;
      }

      if(chequeNoController.text.length == 0){
        showErrorMessage("Please Write Cheque No", context);
        return;
      }

      if(chequeIssueDateController.text == ""){
        showErrorMessage("Please Select Cheque Issue Date", context);
        return;
      }
    }


//    print(postData);

//
    try {
      await LoanProposalService.disburseProposal(
          postData);
      showSuccessMessage(
          "Successfully Loan Proposal Approved",
          context);
      Navigator.of(context).pushReplacementNamed(
          "/loan-proposal");
    } on CustomException catch(ex){
      showErrorMessage(ex.message, context);
    }
  }

  String showInstallmentStartDate(dynamic lp){
    return DateFormat("dd MMM y").format(DateTime.parse(lp['installment_start_date'].toString()));
  }

  String showAppliedAmount(dynamic lp){
    double _appliedAmount = double.parse(lp["applied_amount"].toString());
    return _appliedAmount.toStringAsFixed(0);
  }

  String showApprovedAmount(dynamic lp){
    double _approvedAmount = double.parse(lp['approved_amount'].toString());
    return _approvedAmount.toStringAsFixed(0);
  }

  String showLoanInstallment(dynamic lp){
    double _loanInstallment = double.parse(lp["loan_installment"].toString());
    return _loanInstallment.toStringAsFixed(0);
  }

  String showIntInstallment(dynamic lp){
    double _scInstallment = double.parse(lp['sc_installment'].toString());
    return _scInstallment.toStringAsFixed(0);
  }

  String getDisburseType(dynamic id){
    if(id==1){
      return "Once at a time";
    }else if(id==102){
      return "Partial";
    }
  }

  String getTransType(dynamic id){
    if(id==101){
      return "CASH";
    }else if(id==102){
      return "BANK";
    }
  }

  Widget showLoader() {
    return (processing)? Center(
        child:Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height+250,
        width: MediaQuery.of(context).size.width,
        child:Center(
            child:CustomDialog(showProgress: true,
              progressCallback: this.downLoadProgressUi,)) )) :
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
  void didChangeDependencies() {
    Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    lp = args['proposal'];
//    print(lp);
    principalLoan.text = lp['applied_amount'].toString();
  }

}