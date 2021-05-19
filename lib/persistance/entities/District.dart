class District{
  
  final int id;
  final int divisionId;
  final String districtCode;
  final String districtName;

  District({this.id,this.divisionId,this.districtCode,this.districtName});

  factory District.fromJson(Map<String,dynamic> json){
    return District(
      id: int.parse(json['id']),
      divisionId: int.parse(json['division_id']),
      districtCode: json['district_code'],
      districtName: json['district_name']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'division_id': divisionId,
      'district_code': districtCode,
      'district_name': districtName
    };
  }
}