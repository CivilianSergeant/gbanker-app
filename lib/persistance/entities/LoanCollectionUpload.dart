class LoanCollectionUpload{
  String collectionDate;
  String userId;
  String apiVersion;
  List<Map<String,dynamic>> collections;

  LoanCollectionUpload(String date,String uid,String apiVersion,
      List<Map<String,dynamic>> c){
    this.collectionDate = date;
    this.userId = uid;
    this.apiVersion = apiVersion;
    this.collections = c;

  }

  Map<String,dynamic> toMap(){
    return{
      'CollectionDate': collectionDate,
      'UserId':userId,
      'APIVersion':apiVersion,
      'Collections':collections
    };
  }
}