class Village{
  final int id;
  final String subDistrictCode;
  final String unionCode;
  final String villageCode;
  final String villageName;

  Village({this.id,this.subDistrictCode,this.unionCode,this.villageCode,
  this.villageName});

  factory Village.fromJson(Map<String,dynamic> json){
    return Village(
      id: int.parse(json['id']),
      subDistrictCode: json['sub_district_code'],
      unionCode: json['union_code'],
      villageCode: json['village_code'],
      villageName: json['village_name']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'sub_district_code': subDistrictCode,
      'union_code': unionCode,
      'village_code': villageCode,
      'village_name': villageName
    };
  }
}