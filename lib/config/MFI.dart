import 'package:gbanker/config/AppConfiguration.dart';

class MFI extends AppConfiguration {
  String orgName;
  String orgUrl;
  String port;

  MFI(){
    this.port = "80";
    this.orgUrl = "http://app.ghrmplus.com/";
    this.orgName = "MFI";

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