import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Guarantor.dart';
import 'package:gbanker/persistance/entities/LoanProposal.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/persistance/tables/guarantors_table.dart';
import 'package:gbanker/persistance/tables/investors_table.dart';
import 'package:gbanker/persistance/tables/loan_proposals_table.dart';
import 'package:gbanker/persistance/tables/purposes_table.dart';
import 'package:sqflite/sqflite.dart';

class LoanProposalService {

  static const LOAN_TERM_VALIDATE = "api/loan-proposal/validate-term";
  static const LOAN_PROPOSAL_SAVE = "api/loan-proposal/save";
  static const LOAN_PROPOSALS = "api/loan-proposal/list";
  static const LOAN_PROPOSAL_APPROVE = "api/loan-proposal/approve";
  static const LOAN_PROPOSAL_DISBURSE = "api/loan-proposal/disburse";
  static const LOAN_PROPOSAL_DELETE = "api/loan-proposal/delete";


  static Future<void> truncateLoanProposals() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+LoanProposalsTable().tableName);
  }

  static Future<int> addLoanProposal(LoanProposal loanProposal) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(LoanProposalsTable().tableName, loanProposal.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }

  static Future<List<Map<String,dynamic>>> getLoanProposals() async {

      final Database db = await DbProvider.db.database;
      String productSql = "(SELECT p.product_name FROM products p WHERE p.product_id = lp.product_id) as product_name";
      String productCodeSql = "(SELECT p1.product_code FROM products p1 WHERE p1.product_id = lp.product_id) as product_code";
      String minlimit = "(SELECT p1.min_limit FROM products p1 WHERE p1.product_id = lp.product_id) as min_limit";
      String duration = "(SELECT p1.duration FROM products p1 WHERE p1.product_id = lp.product_id) as duration";
      String productloanInstallment = "(SELECT p1.loan_installment FROM products p1 WHERE p1.product_id = lp.product_id) as prod_loan_installment";
      String productIntInstallment = "(SELECT p1.interest_installment FROM products p1 WHERE p1.product_id = lp.product_id) as prod_int_installment";
//      String centerSql = "(SELECT c.center_name FROM centers c WHERE c.id = lp.center_id) as center_name";
//      String centerCodeSql = "(SELECT c1.center_code FROM centers c1 WHERE c1.id = lp.center_id) as center_code";
      //String investorName = "(SELECT inv.investor_name FROM investors inv WHERE inv.id = lp.investor_id) as investor_name";
//      String memberSql = "members.first_name as member_name"; //"(SELECT mp1.member_name AS member_name FROM members mp1 WHERE mp1.member_id=lp.member_id GROUP BY member_code) as member_name";
//      String memberCodeSql = "members.member_code"; //"(SELECT mp2.member_code AS member_code FROM members mp2 WHERE mp2.member_id=lp.member_id GROUP BY member_code) as member_code";
      String sql="SELECT lp.id,lp.loan_summary_id,members.member_id as mid,members.office_id,members.created_user,lp.center_id, lp.member_id, "
          "lp.product_id, "+productSql+","+productCodeSql+",members.co_applicant_name, lp.co_applicant_name as coApplicantName,lp.center_code,lp.center_name,"
          "lp.member_name,lp.member_code,"+minlimit+","+duration+", applied_amount,"
          +productloanInstallment+","+productIntInstallment+",loan_installment, sc_installment,investor_id,"
          "purpose_id,purposes.purpose_name, purposes.purpose_code, investors.investor_code,investors.investor_name, "
          "disbursement_type_id, trans_type_id, guarantor.name as guarantor_name,lp.guarantor_name as gname, is_approved,is_disbursed,applied_amount,approved_amount,"
          " installment_start_date, proposal_no, product_installment_method_id, product_installment_method_name,"
          " pi_loan_installment, pi_int_installment "
          " FROM "+LoanProposalsTable().tableName+" AS lp LEFT JOIN members on members.member_id = lp.member_id "
          " JOIN ${PurposesTable().tableName} as purposes on purposes.id = lp.purpose_id "
          " JOIN ${InvestorsTable().tableName} as investors on investors.id = lp.investor_id "
          " LEFT JOIN ${GuarantorsTable().tableName} as guarantor on guarantor.loan_proposal_id = lp.id";
      List<Map<String,dynamic>> maps = await db.rawQuery(sql);

//      print(maps);
      return maps;
   // }
  }

  static Future<bool> existLoanProposal({int loanSummaryId}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.query(LoanProposalsTable().tableName,where:"loan_summary_id=?",
        whereArgs: [loanSummaryId]);
    return (maps.length>0)? true:false;
  }

  static Future<int> saveLoanProposalFromApi(dynamic map,{int orgId}) async {
    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(LoanProposalsTable().tableName,
        LoanProposal(
          loanSummaryId: map['LoanSummaryId'],
          officeId: map['OfficeID'],
          centerId: map['CenterID'],
          memberId: map['MemberID'],
          memberCode: map['MemberCode'],
          memberName: map['MemberName'],
          centerCode: map['CenterCode'],
          centerName: map['CenterName'],
          guarantorName: map['Guarantor'],
          productId: map['ProductID'],
          investorId: map['InvestorID'],
          purposeId: map['PurposeID'],
          duration: map['Duration'],
          transType: map['TransType'],
          bankName: map['BankName'],
          chequeNo: map['ChequeNo'],
          loanTerm: map['LoanTerm'],
          appliedAmount: map['ProposalAmount'],
          loanInstallment: double.parse(map['LoanInstallment'].toString()).toInt(),
          scInstallment: double.parse(map['IntInstallment'].toString()).toInt(),
          disbursementTypeId: map['DisbursementType'],
          isApproved: map['IsApproved'],
          coApplicantName: map['CoApplicantName'],
          chequeIssueDate: map['ChequeIssueDate'],
          approvedAmount: map['PrincipalLoan'],
          securityBankName: map['SecurityBankName'],
          securityBranchName: map['SecurityBranchName'],
          securityChequeNo: map['SecurityBankChequeNo'],
          memberPassBookNo: map['MemberPassBookRegisterID'],
          approveDate: map['ProposalDate'],
          interestRate: map['InterestRate'],
          intCharge: map['IntCharge'],
          disburseDate: map['DisburseDate'],
          isDisbursed: (map['DisburseDate'] != null)? true : false,
          installmentStartDate: map['InstallmentStartDate'],
          proposalNo: (orgId == 1)? map['ProposalNo'] : null,
          productInstallmentMethodName: (orgId == 1)? map['ProductInstallmentMethodName'] : null,
          productInstallmentMethodId: (orgId == 1)? int.parse(map['ProductInstallmentMethodId'].toString()) : null,
          piLoanInstallment: (orgId == 1)? map['ProductInstallmentLoanInstallment'] : null,
          piIntInstallment: (orgId == 1)? map['ProductInstallmentIntInstallment'] : null
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return inserted;
  }


  static Future<dynamic> validateTerm(dynamic postData) async{
    bool netStatus = await NetworkService.check();
    if(!netStatus){
      return throw CustomException("Sorry! Internet not available",500);
    }
    Setting setting = await SettingService.getSetting("orgUrl");
    dynamic fetchResult = await NetworkService.post(setting.value + LOAN_TERM_VALIDATE, postData, header: {
      "Content-Type":"application/json"
    });

    return fetchResult;

  }

  static Future<int> saveLoanProposal(Map<String, Object> postData) async {
    bool netStatus = await NetworkService.check();
    if(!netStatus){
      return throw CustomException("Sorry! Internet not available",500);
    }
//    print(postData);
    Setting setting = await SettingService.getSetting("orgUrl");
    dynamic fetchResult = await NetworkService.post(setting.value + LOAN_PROPOSAL_SAVE, postData, header: {
      "Content-Type":"application/json"
    });

//    print(fetchResult);
    if(fetchResult ==null){
      return throw CustomException("Sorry! Try again Later",500);
    }

    int inserted = 0;
    if(fetchResult['status']=="true"){
//    if(true){ //
      final Database db = await DbProvider.db.database;
      int inserted = await db.insert(LoanProposalsTable().tableName,LoanProposal(
        loanSummaryId: fetchResult['inserted'],
        officeId: postData['officeId'],
        centerId: postData['centerId'],
        memberId: int.parse(postData['memberId']),
        frequencyMode: postData['frequency'],
        mainProductCode: postData['mainProductCode'],
        subMainProductCode: postData['subMainProductCode'],
        productId: postData['productId'],
        investorId: postData['investorId'],
        loanTerm: int.parse(postData['loanTerm']),
        purposeId: postData['purposeId'],
        disbursementTypeId: postData['disbursementType'],
        appliedAmount: double.parse(postData['appliedAmount']),
        duration: int.parse(postData['duration']),
        coApplicantName: postData['coApplicantName'],
        memberPassBookNo: int.parse(postData['memberPassBookNo']),
        loanInstallment: int.parse(postData['loanInstallment']),
        scInstallment: int.parse(postData['scInstallment']),
        transType: postData['transType'],
        securityBankName: postData['sequrityBankName'],
        securityBranchName: postData['sequrityBranchName'],
        securityChequeNo: postData['sequrityChequeNo'],
        isApproved: false,
        isDisbursed: false,
        piLoanInstallment: postData['piLoanInstallment'],
        piIntInstallment: postData['piInterestInstallment'],
        productInstallmentMethodId: postData['productInstallmentMethodId'],
        productInstallmentMethodName: postData['productInstallmentMethodName'],
        proposalNo: postData['proposalNo']


      ).toMap(),conflictAlgorithm: ConflictAlgorithm.replace);

      if(inserted >0 ){
        db.insert(GuarantorsTable().tableName, Guarantor(
          loanProposalId: inserted,
          name: postData['guarantorName'],
          father: postData['guarantorFather'],
          relation: postData['guarantorRelation'],
          dateOfBirth: postData['dateOfBirth'],
          age: postData['age'],
          address:postData['address']
        ).toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    return inserted;
  }

  static Future<dynamic> fetchLoanProposals() async {
    bool networkStatus = await NetworkService.check();
    if(!networkStatus){
      return null;
    }
    Setting setting = await SettingService.getSetting("orgUrl");
    Setting settingGuid = await SettingService.getSetting("guid");
    var user = await UserService.getUserByGuid(settingGuid.value);

    Map<String,dynamic> map = await NetworkService.post(setting.value+LOAN_PROPOSALS, {

      "userId":user.username,
      "officeId": user.officeId
    }, header: {
      "Access-Control-Request-Method":"GET",
      "Content-Type":"application/json"});

    return map;
  }

  static Future<void> approveProposal(Map<String,dynamic> postData) async {
    bool networkStatus = await NetworkService.check();
    if(!networkStatus){
      return throw CustomException("Internet Connection not avaailable",500);
    }

    Setting setting = await SettingService.getSetting("orgUrl");


    Map<String,dynamic> map = await NetworkService.post(setting.value+LOAN_PROPOSAL_APPROVE,
        postData, header: {"Content-Type":"application/json"});
//    print(map);
    if(map['status']=="true"){
        dynamic loanProposalApprove = map['loanProposalApprove'];
        final Database db = await DbProvider.db.database;
        var updatedValue = {
          "installment_start_date": loanProposalApprove['InstallmentStartDate'],
          "int_charge": loanProposalApprove['IntCharge'],
//          "loan_installment": loanProposalApprove['LoanInstallment'],
//          "sc_installment":loanProposalApprove['IntInstallment'],
          "approved_amount": postData['approvedAmount'],
          "is_approved":1,
          "approve_date": DateTime.now().toString()
        };
        db.update(LoanProposalsTable().tableName, updatedValue,where: "id=?",whereArgs: [postData['id']]);
    }else{
      throw CustomException("Sorry! Unable to approve",500);
    }


  }

  static Future<void> disburseProposal(Map<String,dynamic> postData) async {
    bool networkStatus = await NetworkService.check();
    if(!networkStatus){
      return throw CustomException("Internet Connection not avaailable",500);
    }

    Setting setting = await SettingService.getSetting("orgUrl");

    Setting trxDateSetting = await SettingService.getSetting("transactionDate");
    Map<String,dynamic> map = await NetworkService.post(setting.value+LOAN_PROPOSAL_DISBURSE,
        postData, header: {"Content-Type":"application/json"});

    if(map['status']=="true"){
//      print(postData);
      final Database db = await DbProvider.db.database;
      var updatedValue = {
        "bank_name": postData['bankName'],
        "cheque_no": postData['chequeNo'],
        "cheque_issue_date": postData['chequeIssueDate'],
        "is_disbursed":1,
        "disburse_date": trxDateSetting.value.toString()
      };
      await db.update(LoanProposalsTable().tableName, updatedValue,where: "id=?",whereArgs: [postData['id']]);
    }else{
      throw CustomException("Sorry! Unable to disburse",500);
    }


  }

  static Future<int> deleteLoanProposal(dynamic postData) async{
    bool networkStatus = await NetworkService.check();
    if(!networkStatus){
      return throw CustomException("Internet Connection not avaailable",500);
    }

    Setting setting = await SettingService.getSetting("orgUrl");


    Map<String,dynamic> map = await NetworkService.post(setting.value+LOAN_PROPOSAL_DELETE,
        postData, header: {"Content-Type":"application/json"});

    final Database db = await DbProvider.db.database;
    int deleted = await db.delete(LoanProposalsTable().tableName,where:"loan_summary_id=?",whereArgs: [postData['loanSummaryId']]);

    return deleted;

  }




}