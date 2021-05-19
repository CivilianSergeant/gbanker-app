import 'package:url_launcher/url_launcher.dart';

class CustomLauncher {
  static Future<void> launchURL({String url}) async {
    var _url = (url != null)? url : 'market://details?id=gBankerPMS.gBankerPMS';
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }
}