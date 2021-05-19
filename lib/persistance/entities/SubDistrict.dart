class SubDistrict{

  final int id;
  final int districtId;
  final String subDistrictCode;
  final String subDistrictName;

  SubDistrict({this.id,this.districtId,this.subDistrictCode,this.subDistrictName});

  factory SubDistrict.fromJson(Map<String,dynamic> json){
    return SubDistrict(
      id: int.parse(json['id']),
      districtId: int.parse(json['district_id']),
      subDistrictCode: json['sub_district_code'],
      subDistrictName: json['sub_district_name']
    );
  }

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'district_id':districtId,
      'sub_district_code':subDistrictCode,
      'sub_district_name':subDistrictName
    };
  }
}