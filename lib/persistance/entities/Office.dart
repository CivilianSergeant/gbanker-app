class Office{
  final int id;
  final String officeId;
  final String officeCode;
  final String officeName;

  Office({this.id,this.officeId,this.officeCode,this.officeName});

  factory Office.fromJson(Map<String,dynamic> json){
    return Office(
      id: int.parse(json['id']),
      officeId: json['office_id'],
      officeCode: json['office_code'],
      officeName: json['office_name']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'office_id': officeId,
      'office_code': officeCode,
      'office_name': officeName
    };
  }


}