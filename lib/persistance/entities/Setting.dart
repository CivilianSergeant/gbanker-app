class Setting{
  final int id;
  final String option;
  final dynamic value;

  Setting({this.id,this.option,this.value});

  factory Setting.fromJson(Map<String,dynamic> json){
    return Setting(
      id: int.parse(json['id']),
      option: json['option'],
      value: json['value']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'option': option,
      'value': value
    };
  }
}