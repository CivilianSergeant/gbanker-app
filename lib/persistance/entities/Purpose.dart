class Purpose {
  int id;
  String purposeCode;
  String purposeName;
  int orgId;
  bool isActive;
  String isActiveDate;
  String createUser;
  String createDate;
  String mainSector;
  String mainSectorName;
  String subSector;
  String subSectorName;
  String mainLoanSector;

  Purpose({this.id,this.purposeCode,this.purposeName,
  this.orgId, this.isActive, this.isActiveDate,this.createUser,
  this.createDate, this.mainSector, this.mainSectorName,
  this.subSector, this.subSectorName, this.mainLoanSector});

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "purpose_code":purposeCode,
      "purpose_name":purposeName,
      "org_id": orgId,
      "is_active": (isActive)? 1 : 0,
      "is_active_date": isActiveDate,
      "create_user":createUser,
      "create_date":createDate,
      "main_sector":mainSector,
      "main_sector_name":mainSectorName,
      "sub_sector":subSector,
      "sub_sector_name": subSectorName,
      "main_loan_sector": mainLoanSector
    };
  }
}