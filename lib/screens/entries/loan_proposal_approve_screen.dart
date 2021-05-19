import 'package:flutter/material.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/loan_proposal_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/group_caption.dart';

class LoanProposalApproveScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoanProposalApproveState();
}

class _LoanProposalApproveState extends State<LoanProposalApproveScreen>{

  TextEditingController principalLoan = TextEditingController();
  String loanInstallment="";
  String intInstallment="";
  String processingInfo = "Processing";
  bool processing = false;
  User user;
  Map<String,dynamic> lp;

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(
      title: "Loan Proposal Approve", bgColor: ColorList.Colors.primaryColor,
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
                        GroupCaption(caption: (lp["member_name"] != null)? lp["member_name"] : "N/A",size:14)
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GroupCaption(caption:"Center:",size:14),
                        GroupCaption(caption: (lp["center_name"] != null)?lp["center_name"]: "N/A",size:14)
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GroupCaption(caption:"Product:",size:14),
                        GroupCaption(caption: lp['product_code']+" "+lp["product_name"],size:14)
                      ],),
                    showProductInstalment(),
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
                        GroupCaption(caption: showCoApplicantName(lp),size:14)
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GroupCaption(caption:"Guarantor Name:",size:14),
                        GroupCaption(caption: showGuarantor(lp),size:14)
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
                        GroupCaption(caption: double.parse(lp["applied_amount"].toString()).round().toString(),size:14)
                      ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GroupCaption(caption:"Approve Amount:",size:14),
                    SizedBox(
                        width: 150,
                        child:TextField(
                          controller: principalLoan,
                          onTap: (){
                            if(principalLoan .text.length>0) {
                              principalLoan.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                  principalLoan.text.length);
                            }
                          },
                          textAlign:TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) async {
                            try {
                              if(value.length>0) {
                                handleApproveAmountChange(value);
                              }

                            } on Exception catch( ex) {
//                              print(ex.toString());
                            }
                          },
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                              ),
                              hintText: "Approved Amount"
                          ),
                        )
                    )
                  ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GroupCaption(caption:"Loan Installment:",size:14),
                        GroupCaption(caption: ((loanInstallment.length>0)? loanInstallment : double.parse(lp["loan_installment"].toString()).round().toString()),size:14)
                      ],),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GroupCaption(caption:"${showScOrInt()} Installment:",size:14),
                        GroupCaption(caption: (intInstallment.length>0)?intInstallment: double.parse(lp["sc_installment"].toString()).round().toString(),size:14)
                      ],),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton(
                            color: Colors.green,
                            child: Text("Approve",style: TextStyle(
                              color: Colors.white
                            ),),
                            onPressed: () async {

                              setState(() {
                                processing = true;
                              });
                              await handleApprove();
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

  String showCoApplicantName(dynamic lp){
    if(lp['co_applicant_name']!=null){
      return lp['co_applicant_name'];
    }else if(lp['coApplicantName'] != null){
      return lp['coApplicantName'];
    }
    return "N/A";
  }


  String showGuarantor(dynamic lp){
    if(lp["guarantor_name"] !=null){
      return lp["guarantor_name"];
    }else if(lp['gname'] != null){
      return lp['gname'];
    }
    return "N/A";
  }

  Widget showProposalNo(){
    if(user != null && user.orgId == 1 && lp["proposal_no"] != null){
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

  void handleApproveAmountChange(String value){

    double appliedAmount = double.parse(value);
    double _loanInstallment = 0;
    double _scInstallment = 0;

    if(user != null && user.orgId != 1) {
      _loanInstallment = (lp['prod_loan_installment'] * appliedAmount);
      _scInstallment = (appliedAmount *
          (lp['prod_loan_installment'] + lp['prod_int_installment'])) -
          _loanInstallment;
    }else{
      _loanInstallment = (lp['pi_loan_installment'] * appliedAmount);
      _scInstallment = (appliedAmount * (lp['pi_loan_installment'] + lp['pi_int_installment'])) - _loanInstallment;
      _loanInstallment = (_loanInstallment / 1000);
      _scInstallment = (_scInstallment / 1000);
    }
    int loanInstallmentAmount = _loanInstallment.round();
    int scInstallmentAmount = _scInstallment.round();


    setState(() {
      loanInstallment = loanInstallmentAmount.toStringAsFixed(0);
      intInstallment = scInstallmentAmount.toStringAsFixed(0);
    });
  }

  @override
  void initState() {
    loadData();
  }

  Future<bool> loadData() async {
    Setting settingGuid = await SettingService.getSetting("guid");
    var _user = await UserService.getUserByGuid(settingGuid.value);
    if(mounted) {
      setState(() {
        user = _user;
      });
    }
  }

  Future<void> handleApprove() async {
    Setting settingGuid = await SettingService.getSetting("guid");
    var user = await UserService.getUserByGuid(settingGuid.value);
    if(principalLoan.text.length<=0 || principalLoan.text == "0"){
      showErrorMessage("Approve amount should not be 0", context);
      return;
    }
    double _principalLoan = double.parse(principalLoan.text);
    if(_principalLoan< lp['min_limit']){
      showErrorMessage("Approve amount should not be less than min limit ${lp['min_limit']}",context);
      return;
    }

    if(_principalLoan > lp['applied_amount']){
      showErrorMessage("Approve amount should not be greater than Applied amount ${lp['applied_amount']}",context);
      return;
    }

    var postData = {
      "id": lp['id'],
      "officeId": user.officeId,
      "memberId": lp["mid"],
      "productId": lp['product_id'],
      "approvedAmount": principalLoan.text,
      "userId": user.username
    };

    try {
      await LoanProposalService.approveProposal(
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

  Widget showProductInstalment(){
    if(user != null && user.orgId ==1){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GroupCaption(caption:"Prod. Inst. :",size:14),
          GroupCaption(caption: lp['product_installment_method_name'],size:14)
        ],);
    }else{
      return SizedBox.shrink();
    }
  }

  @override
  void didChangeDependencies() {
    Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    lp = args['proposal'];
    double _principalLoan = double.parse(lp['applied_amount'].toString());
    
    principalLoan.text = _principalLoan.toStringAsFixed(0);
//    print("HERE"+lp.toString());
  }
}