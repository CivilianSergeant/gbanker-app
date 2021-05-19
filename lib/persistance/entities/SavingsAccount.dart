class SavingsAccount {

  int id;
  int centerId;
  int memberId;
  int productId;
  double savingInstallment;
  bool isPostedToLedger;

  SavingsAccount({this.id,this.centerId,this.memberId,this.productId,
    this.savingInstallment,this.isPostedToLedger});

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'center_id': centerId,
      'member_id': memberId,
      'product_id': productId,
      'savings_installment':savingInstallment,
      'is_posted_to_ledger':(isPostedToLedger)? 1 : 0
    };
  }
}