import 'package:gbanker/config/AppConfiguration.dart';

class Verc extends AppConfiguration{
  String orgName;
  String orgUrl;
  String port;

  Verc(){
    this.port = "6130";
    this.orgUrl  = "http://gbanker.info:${this.port}/";
    this.orgName = "Verc";
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
    return "info";
  }


}