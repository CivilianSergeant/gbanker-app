class Group{
  final int id;
  final String groupCode;
  final int officeId;

  Group({this.id,this.groupCode, this.officeId});

  factory Group.fromJson(Map<String,dynamic> json){
    return Group(
      id: int.parse(json['id']),
      groupCode: json['group_code'],
      officeId: json['office_id']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'group_code': groupCode,
      'office_id': officeId
    };
  }
}