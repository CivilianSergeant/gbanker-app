class CustomException implements Exception{

  String _message;
  int _code;

  CustomException(String s,int c){
    _message = s;
    _code =c;
  }

  String get message {
    return this._message;
  }

}