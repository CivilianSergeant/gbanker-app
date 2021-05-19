class LoanCollectionHistory {

  int id;
  int collectionId;
  int officeId;
  int centerId;
  int productId;
  int memberId;
  double amount;
  double recoverable;
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

  LoanCollectionHistory({this.id,this.collectionId,this.officeId,this.centerId,this.productId,
    this.memberId,this.amount,this.recoverable,
    this.loanRecovery,
    this.summaryId,this.trxType,this.token,this.installmentDate,
    this.productType,this.loanInstallment,this.intInstallment,this.intCharge,
  this.fine,this.createdAt});


  Map<String, dynamic> toMap(){
    return {
      "id":id,
      "collection_id": collectionId,
      "office_id": officeId,
      "center_id": centerId,
      "product_id": productId,
      "member_id": memberId,
      "amount": amount,
      "recoverable":recoverable,
      "loan_recovery":loanRecovery,
      "summary_id": summaryId,
      "trx_type": trxType,
      "token": token,
      "installment_date":installmentDate,
      "product_type":productType,
      "loan_installment": loanInstallment,
      "int_installment": intInstallment,
      "int_charge": intCharge,
      "fine":fine,
      "created_at":createdAt
    };
  }

}