class MemberCategory{
  final int id;
  final String categoryCode;
  final String categoryName;

  MemberCategory({this.id,this.categoryCode,this.categoryName});

  factory MemberCategory.fromJson(Map<String,dynamic> json){
    return MemberCategory(
      id: int.parse(json['id']),
      categoryCode: json['category_code'],
      categoryName: json['category_name']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'category_code': categoryCode,
      'category_name': categoryName
    };
  }
}