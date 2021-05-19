class Division{
  final int id;
  final int countryId;
  final String divisionCode;
  final String divisionName;


  Division({this.id,this.countryId,this.divisionCode,this.divisionName});

  factory Division.fromJson(Map<String,dynamic> json){
    return Division(
      id: int.parse(json['id']),
      countryId: int.parse(json['country_id']),
      divisionCode: json['division_code'],
      divisionName: json['division_name']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'country_id': countryId,
      'division_code': divisionCode,
      'division_name': divisionName
    };
  }
}