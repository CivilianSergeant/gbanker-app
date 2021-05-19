class Country{

  final int id;
  final String countryCode;
  final String countryName;
  final String countryShortCode;
  final String isoCode3;
  final bool status;

  Country({this.id,this.countryCode,this.countryName,this.countryShortCode,
  this.isoCode3,this.status});

  factory Country.fromJson(Map<String,dynamic> json){
    return Country(
      id: int.parse(json['id']),
      countryCode: json['country_code'],
      countryName: json['country_name'],
      countryShortCode: json['country_short_code'],
      isoCode3: json['iso_code_3'],
      status: json['status']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'country_code': countryCode,
      'country_name': countryName,
      'country_short_code': countryShortCode,
      'iso_code_3': isoCode3,
      'status': status
    };
  }


}