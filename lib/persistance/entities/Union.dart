class Union{
  final int id;
  final String subDistrictCode;
  final String unionCode;
  final String unionName;

  Union({this.id,this.subDistrictCode,this.unionCode,this.unionName});

  factory Union.fromJson(Map<String,dynamic> json){
    return Union(
      id: int.parse(json['id']),
      subDistrictCode: json['sub_district_code'],
      unionCode: json['union_code'],
      unionName: json['union_name']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'sub_district_code': subDistrictCode,
      'union_code': unionCode,
      'union_name': unionName,
    };
  }
}