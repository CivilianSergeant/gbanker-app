import 'package:gbanker/config/AppConfiguration.dart';
import 'package:gbanker/config/app_config.dart';

class DSK extends AppConfiguration {
  String orgUrl;
  String orgName;
  String port;
  String domain;

  DSK(){
    this.domain = "net";
    this.port = (AppConfig.env == AppConfig.DEV )? "8963" : "8369"; //"6369";
    this.orgUrl = (AppConfig.env == AppConfig.DEV )? "http://gbanker.${this.domain}:${this.port}/":
                  "https://gbanker.${this.domain}:${this.port}";
    this.orgName = "DSK";
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
    return this.domain;
  }




}