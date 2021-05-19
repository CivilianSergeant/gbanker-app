class Misc{
  int id;
  int miscId;
  int officeId;
  int centerId;
  int memberId;
  int productId;
  double amount;
  String transDate;
  String remarks;


  Misc({
    this.id,
    this.miscId,
    this.officeId,
    this.centerId,
    this.memberId,
    this.productId,
    this.amount,
    this.transDate,
    this.remarks
  });

  Map<String, dynamic> toMap(){
    return {
      "id":id,
      "misc_id":miscId,
      "office_id": officeId,
      "center_id": centerId,
      "member_id":memberId,
      "product_id": productId,
      "amount": amount,
      "transaction_date": transDate,
      "remarks": remarks
    };
  }
}