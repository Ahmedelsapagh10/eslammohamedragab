import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Launcher {
  static Future<void> open(String url) async {
    if (!await url_launcher.launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
