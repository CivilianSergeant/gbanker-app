import 'package:gbanker/config/AppConfiguration.dart';

class GB extends AppConfiguration{

  String orgUrl;
  String orgName;
  String port;

  GB(){
    this.port = "80";
    this.orgName = "GB";
    this.orgUrl  = "http://gbdemo.ghrmplus.com/";
  }

  @override
  String getOrgName() {
    return this.orgName;
  }

  @override
  String getOrgUrl() {
    return this.orgUrl;
  }

  @override
  String getPort() {
    return this.port;
  }

  @override
  String getDomain() {
    return "com";
  }


}