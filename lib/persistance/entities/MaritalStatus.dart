class MaritalStatus{
  final int id;
  final String text;
  final String value;
  final bool selected;

  MaritalStatus({this.id,this.text,this.value,this.selected});

  factory MaritalStatus.fromJson(Map<String,dynamic> json){
    return MaritalStatus(
        id: int.parse(json['id']),
        text: json['text'],
        value: json['value'],
        selected: json['selected']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'text': text,
      'value': value,
      'selected': selected
    };
  }
}