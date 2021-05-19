class BirthPlace{
  
  final int id;
  final String divisionCode;
  final String districtCode;
  final String districtName;

  BirthPlace({this.id,this.divisionCode,this.districtCode,this.districtName});

  factory BirthPlace.fromJson(Map<String,dynamic> json){
    return BirthPlace(
      id: int.parse(json['id']),
      divisionCode: json['division_code'],
      districtCode: json['district_code'],
      districtName: json['district_name']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'division_code': divisionCode,
      'district_code': districtCode,
      'district_name': districtName
    };
  }
}