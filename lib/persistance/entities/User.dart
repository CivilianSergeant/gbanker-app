class User{
  final int id;
  final String username;
  final String firstname;
  final String password;
  final String guid;
  final int orgId;
  final int officeId;
  final String officeName;

  User({this.id,this.username,this.firstname,this.password,this.guid,
    this.orgId,this.officeId,this.officeName});

  factory User.fromJson(Map<String,dynamic> map){
    return User(
      id:int.parse(map['id']),
      username: map['username'],
      firstname: map['firstname'],
      password: map['password'],
      guid:map['guid'],
      orgId: int.parse(map['orgId']),
      officeId: map['officeId'],
      officeName: map['officeName']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'username': username,
      'firstname':firstname,
      'password': password,
      'guid': guid,
      'orgId' : orgId,
      'officeId': officeId,
      'officeName': officeName
    };
  }
}