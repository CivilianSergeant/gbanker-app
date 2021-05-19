class LoanProposal{
  int id;
  int loanSummaryId;
  int officeId;
  int centerId;
  int memberId;
  String memberName;
  String memberCode;
  String centerCode;
  String centerName;
  String frequencyMode;
  String mainProductCode;
  String subMainProductCode;
  int productId;
  int investorId;
  int loanTerm;
  int purposeId;
  int disbursementTypeId;
  double appliedAmount;
  int duration;
  String coApplicantName;
  String guarantorName;
  int memberPassBookNo;
  int loanInstallment;
  int scInstallment;
  int transType;
  String securityBankName;
  String securityBranchName;
  String securityChequeNo;
  bool isApproved;
  bool isDisbursed;
  String disburseDate;
  String bankName;
  String chequeNo;
  String chequeIssueDate;
  double approvedAmount;
  String approveDate;
  double intCharge;
  double interestRate;
  String installmentStartDate;
  String proposalNo;
  int productInstallmentMethodId;
  String productInstallmentMethodName;
  double piLoanInstallment;
  double piIntInstallment;

  LoanProposal({
    this.id,
    this.loanSummaryId,
    this.officeId,
    this.centerId,
    this.memberId,
    this.memberCode,
    this.memberName,
    this.centerCode,
    this.centerName,
    this.guarantorName,
    this.frequencyMode,
    this.mainProductCode,
    this.subMainProductCode,
    this.productId,
    this.investorId,
    this.loanTerm,
    this.purposeId,
    this.disbursementTypeId,
    this.appliedAmount,
    this.duration,
    this.coApplicantName,
    this.memberPassBookNo,
    this.loanInstallment,
    this.scInstallment,
    this.transType,
    this.securityBankName,
    this.securityBranchName,
    this.securityChequeNo,
    this.isApproved,
    this.isDisbursed,
    this.disburseDate,
    this.bankName,
    this.chequeNo,
    this.chequeIssueDate,
    this.approvedAmount,
    this.approveDate,
    this.intCharge,
    this.interestRate,
    this.installmentStartDate,
    this.proposalNo,
    this.productInstallmentMethodId,
    this.productInstallmentMethodName,
    this.piLoanInstallment,
    this.piIntInstallment
  });

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      "loan_summary_id":loanSummaryId,
      "office_id":officeId,
      "center_id": centerId,
      "member_id": memberId,
      "member_name":memberName,
      "member_code": memberCode,
      "center_code": centerCode,
      "center_name": centerName,
      "guarantor_name": guarantorName,
      "frequency_mode": frequencyMode,
      "main_product_code":mainProductCode,
      "sub_main_product_code":subMainProductCode,
      "product_id": productId,
      "investor_id":investorId,
      "loan_term":loanTerm,
      "purpose_id":purposeId,
      "disbursement_type_id":disbursementTypeId,
      "applied_amount": appliedAmount,
      "duration": duration,
      "co_applicant_name": coApplicantName,
      "member_pass_book_no": memberPassBookNo,
      "loan_installment": loanInstallment,
      "sc_installment": scInstallment,
      "trans_type_id": transType,
      "security_bank_name": securityBankName,
      "security_branch_name": securityBranchName,
      "security_cheque_no": securityChequeNo,
      "is_approved": (isApproved)? 1 : 0,
      "is_disbursed": (isDisbursed != null && isDisbursed == true)? 1 : 0,
      "disburse_date": disburseDate,
      "installment_start_date": installmentStartDate,
      "bank_name": bankName,
      "cheque_no": chequeNo,
      "cheque_issue_date": chequeIssueDate,
      "approved_amount": approvedAmount,
      "approve_date":approveDate,
      "int_charge":intCharge,
      "interest_rate":interestRate,
      "proposal_no":proposalNo,
      "product_installment_method_id":productInstallmentMethodId,
      "product_installment_method_name":productInstallmentMethodName,
      "pi_loan_installment":piLoanInstallment,
      "pi_int_installment":piIntInstallment
    };
  }
}