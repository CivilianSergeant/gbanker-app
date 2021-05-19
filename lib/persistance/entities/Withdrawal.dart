class Withdrawal {

  int id;
  int officeId;
  int centerId;
  int productId;
  int memberId;
  double amount;
  double dueAmount;
  double loanRecovery;
  int summaryId;
  int trxType;
  String token;
  String installmentDate;
  int productType;
  double loanInstallment;
  double intInstallment;
  double intCharge;
  double fine;
  String createdAt;
  bool isDeleted;

  Withdrawal({this.id,this.officeId,this.centerId,this.productId,this.createdAt,
    this.memberId,this.amount,this.dueAmount,this.loanRecovery, this.summaryId,
    this.trxType,this.token,this.installmentDate,
    this.productType,this.loanInstallment,this.intInstallment,this.intCharge,
    this.fine,this.isDeleted
  });


  Map<String, dynamic> toMap(){
    return {
      "id":id,
      "office_id": officeId,
      "center_id": centerId,
      "product_id": productId,
      "member_id": memberId,
      "amount": amount,
      "due_amount": dueAmount,
      "loan_recovery":loanRecovery,
      "summary_id": summaryId,
      "trx_type": trxType,
      "token": token,
      "installment_date":installmentDate,
      "product_type":productType,
      "loan_installment": loanInstallment,
      "int_installment": intInstallment,
      "int_charge": intCharge,
      "created_at" : createdAt,
      "fine":fine,
      "is_deleted":(isDeleted != null && isDeleted)? 1 : 0
    };
  }

}