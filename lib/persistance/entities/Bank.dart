class Bank{
  int id;
  String bankCode;
  String bankName;


  Bank({this.id,this.bankName,this.bankCode});

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "bank_code": bankCode,
      "bank_name":bankName
    };
  }
}