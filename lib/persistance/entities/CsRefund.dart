import 'dart:core';

class CsRefund{
  int immatureLtsId;
  int savingSummaryId;
  double calcInterest;
  double deposit;
  double withdrawal;
  double interest;
  bool transferred;
  String transDate;
  int productId;
  int officeId;
  String createUser;
  String createDate;
  double currentInterest;
  double interestRate;
  double withdrawalRate;
  String openingDate;
  double savingInstallment;
  int duration;

  CsRefund({
    this.immatureLtsId,
    this.savingSummaryId,
    this.calcInterest,
    this.deposit,
    this.withdrawal,
    this.interest,
    this.transferred,
    this.transDate,
    this.productId,
    this.officeId,
    this.createUser,
    this.createDate,
    this.currentInterest,
    this.interestRate,
    this.withdrawalRate,
    this.openingDate,
    this.savingInstallment,
    this.duration
  });

  Map<String,dynamic> toMap(){
    return {
      "immature_lts_id":immatureLtsId,
      "saving_summary_id":savingSummaryId,
      "calc_interest": calcInterest,
      "deposit": deposit,
      "withdrawal":withdrawal,
      "interest":interest,
      "transferred":transferred,
      "trans_date":transDate,
      "product_id":productId,
      "office_id": officeId,
      "create_user":createUser,
      "create_date":createDate,
      "current_interest":currentInterest,
      "interest_rate":interestRate,
      "withdrawal_rate":withdrawalRate,
      "opening_date":openingDate,
      "saving_installment":savingInstallment,
      "duration": duration,
    };
  }
}