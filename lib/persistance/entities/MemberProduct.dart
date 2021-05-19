import 'package:gbanker/persistance/entities/DataSet.dart';

class MemberProduct extends DataSet{
  final int id;
  final int officeId;
  final String officeCode;
  final String officeName;
  final int centerId;
  final String centerCode;
  final String centerName;
  final int memberId;
  final String memberCode;
  final String memberName;
  final int productId;
  final String productCode;
  final String productName;
  final int productType;
  final double loanRecovery;
  final double recoverable;
  final double balance;
  final String installmentDate;
  final int installmentNo;
  final int trxType;
  final int summaryId;
  final double prinBalance;
  final double serBalance;
  final String interestCalculationMethod;
  final int duration;
  final double durationOverLoanDue;
  final double durationOverIntDue;
  final double loanDue;
  final double intDue;
  final double cumIntCharge;
  final double cumInterestPaid;
  final double principalLoan;
  final double loanRepaid;
  final double intCharge;
  final double newDue;
  final String mainProductCode;
  final int doc;
  final String accountNo;
  final double fine;
  final double scPaid;
  final double personalWithdraw;
  final double personalSaving;
  final double cumLoanDue;
  final double cumIntDue;
  final int orgId;
  final String disburseDate;
  final double disburseAmount;
  final int allowFine;


  MemberProduct({
     this.id,this.officeId,this.officeCode,this.officeName,this.centerId,
     this.centerCode,this.centerName,this.memberId,this.memberCode,
     this.memberName,this.productId,this.productCode,this.productName,
     this.productType,this.loanRecovery,this.recoverable,this.balance,
     this.installmentDate,this.installmentNo,this.trxType,this.summaryId,
     this.prinBalance,this.serBalance,this.interestCalculationMethod,
     this.duration,this.durationOverLoanDue,this.durationOverIntDue,
     this.loanDue,this.intDue,this.cumIntCharge,this.cumInterestPaid,
     this.principalLoan,this.loanRepaid,this.intCharge,this.newDue,
     this.mainProductCode,this.doc,this.accountNo,this.fine,this.scPaid,
     this.personalWithdraw,this.personalSaving,this.orgId,
     this.cumLoanDue,this.cumIntDue,
    this.disburseAmount,this.disburseDate,this.allowFine
  });

  factory MemberProduct.fromJson(Map<String,dynamic> json) {
    return MemberProduct(
      id: int.parse(json['id'].toString()),
      officeId: int.parse(json['office_id'].toString()),
      officeCode: json['office_code'],
      officeName: json['office_name'],
      centerId: int.parse(json['center_id'].toString()),
      centerCode: json['center_code'],
      centerName: json['center_name'],
      memberId: int.parse(json['member_id'].toString()),
      memberCode: json['member_code'],
      memberName: json['member_name'],
      productId: int.parse(json['product_id'].toString()),
      productCode: json['product_code'],
      productName: json['product_name'],
      productType: int.parse(json['product_type'].toString()),
      loanRecovery: double.parse(json['loan_recovery'].toString()),
      recoverable: double.parse(json['recoverable'].toString()),
      balance: double.parse(json['balance'].toString()),
      installmentDate: json['installment_date'],
      installmentNo: int.parse(json['installment_no'].toString()),
      trxType: int.parse(json['trx_type'].toString()),
      summaryId: int.parse(json['summary_id'].toString()),
      prinBalance: double.parse(json['prin_balance'].toString()),
      serBalance: double.parse(json['ser_balance'].toString()),
      interestCalculationMethod: json['interest_calculation_method'],
      duration: int.parse(json['duration'].toString()),
      durationOverLoanDue: double.parse(json['duration_over_loan_due'].toString()),
      durationOverIntDue: double.parse(json['duration_over_int_due'].toString()),
      loanDue: double.parse(json['loan_due'].toString()),
      intDue: double.parse(json['int_due'].toString()),
      cumIntCharge: double.parse(json['cum_int_charge'].toString()),
      cumInterestPaid: double.parse(json['cum_interest_paid'].toString()),
      principalLoan: double.parse(json['principal_loan'].toString()),
      loanRepaid: double.parse(json['loan_repaid'].toString()),
      intCharge: double.parse(json['int_charge'].toString()),
      newDue: double.parse(json['new_due'].toString()),
      mainProductCode: json['main_product_code'],
      doc: int.parse(json['doc'].toString()),
      accountNo: json['account_no'],
      fine:  double.parse(json['fine'].toString()),
      scPaid: double.parse(json['sc_paid'].toString()),
      personalWithdraw: double.parse(json['personal_withdraw'].toString()),
      personalSaving: double.parse(json['personal_saving'].toString()),
      orgId: int.parse(json['org_id'].toString()),
      cumLoanDue:  double.parse(json['cum_loan_due'].toString()),
      cumIntDue: double.parse(json['cum_int_due'].toString()),
      disburseAmount: double.parse(json['disburse_amount'].toString()),
      disburseDate: json['disburse_date'],
      allowFine: json['allow_fine']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id, 'office_id':officeId, 'office_code': officeCode,
      'office_name': officeName, 'center_id':centerId,'center_code':centerCode,
      'center_name':centerName,'member_id':memberId,'member_code':memberCode,
      'member_name':memberName,'product_id':productId,'product_code':productCode,
      'product_name':productName,'product_type':productType,
      'loan_recovery':loanRecovery,'recoverable':recoverable,'balance':balance,
      'installment_date':installmentDate,'installment_no':installmentNo,
      'trx_type':trxType,'summary_id':summaryId,'prin_balance':prinBalance,
      'ser_balance':serBalance,'interest_calculation_method':interestCalculationMethod,
      'duration':duration,'duration_over_loan_due':durationOverLoanDue,
      'duration_over_int_due':durationOverIntDue, 'loan_due':loanDue,
      'int_due':intDue,'cum_int_charge':cumIntCharge,'cum_interest_paid':cumInterestPaid,
      'principal_loan':principalLoan,'loan_repaid':loanRepaid,'int_charge':intCharge,
      'new_due':newDue,'main_product_code':mainProductCode,'doc':doc,
      'account_no':accountNo,'fine':fine, 'sc_paid': scPaid,
      'personal_withdraw':personalWithdraw, 'personal_saving':personalSaving,
      'org_id':orgId,'cum_loan_due':cumLoanDue,'cum_int_due':cumIntDue,
      'disburse_date':disburseDate,'disburse_amount':disburseAmount,
      'allow_fine':allowFine
    };
  }

}