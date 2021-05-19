class Investor{
  int id;
  String investorCode;
  String investorName;
  int orgId;
  bool isActive;
  String isActiveDate;
  String createUser;
  String createDate;

  Investor({this.id, this.investorCode, this.investorName,
  this.orgId, this.isActive, this.isActiveDate,
  this.createUser, this.createDate});

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "investor_code":investorCode,
      "investor_name":investorName,
      "org_id": orgId,
      "is_active": isActive,
      "is_active_date": isActiveDate,
      "create_user": createUser,
      "create_date": createDate
    };
  }
}