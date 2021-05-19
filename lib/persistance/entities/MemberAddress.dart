class MemberAddress{

  final int id;
  int memberId;
  final int countryId;
  final int divisionId;
  final int districtId;
  final String subDistrictId;
  final String unionId;
  final String villageId;
  final String zipCode;
  final int perCountryId;
  final int perDivisionId;
  final int perDistrictId;
  final String perSubDistrictId;
  final String perUnionId;
  final String perVillageId;
  final String perZipCode;
  final String permanentAddress;
  final String presentAddress;

  MemberAddress({this.id,this.memberId,this.countryId,this.divisionId,
    this.districtId, this.subDistrictId,this.unionId,this.villageId,
    this.zipCode,this.perCountryId,this.perDivisionId,
    this.perDistrictId, this.perSubDistrictId,this.perUnionId,this.perVillageId,
    this.perZipCode,this.permanentAddress,this.presentAddress,
  });

  factory MemberAddress.fromJson(Map<String,dynamic> json){
    return MemberAddress(
      id: int.parse(json['id']),
      memberId: int.parse(json['member_id']),
      countryId: int.parse(json['country_id']),
      divisionId: int.parse(json['division_id']),
      districtId: int.parse(json['district_id']),
      subDistrictId: json['sub_district_id'].toString(),
      unionId: json['union_id'],
      villageId: json['village_id'],
      zipCode: json['zip_code'],
      permanentAddress: json['permanent_address'],
      presentAddress: json['present_address']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'member_id' : memberId,
      'country_id': countryId,
      'division_id': divisionId,
      'district_id': districtId,
      'sub_district_id': subDistrictId,
      'union_id': unionId,
      'village_id': villageId,
      'zip_code': zipCode,
      'per_country_id': perCountryId,
      'per_division_id': perDivisionId,
      'per_district_id': perDistrictId,
      'per_sub_district_id': perSubDistrictId,
      'per_union_id': perUnionId,
      'per_village_id': perVillageId,
      'per_zip_code': perZipCode,
      'permanent_address': permanentAddress,
      'present_address': presentAddress
    };
  }
}