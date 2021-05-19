class Center{
  final int id;
  final String centerCode;
  final int officeId;
  final String centerName;

  Center({this.id,this.centerCode,this.officeId,this.centerName});

  factory Center.fromJson(Map<String, dynamic> json){
    return Center(
      id: int.parse(json['id']),
      centerCode: json['center_code'],
      officeId: json['office_id'],
      centerName: json['center_name'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'center_code': centerCode,
      'office_id': officeId,
      'center_name': centerName
    };
  }


}