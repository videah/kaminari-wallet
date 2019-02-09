import 'package:kaminari_wallet/utils/certificate.dart';

class LNDConnectInfo {
  final Uri uri;

  get host => uri.host;
  get port => uri.port;
  get address => "${uri.host}:${uri.port}";
  get cert =>
      formatCertificateString(base64UrlToBase64(uri.queryParameters["cert"]));
  get macaroon => base64UrlToBase64(uri.queryParameters["macaroon"]);

  LNDConnectInfo({this.uri});

  @override
  String toString() => LNDConnect.encode(this);
}

class LNDConnect {
  static LNDConnectInfo decode(String uri) {
    String urnScheme = "lndconnect";
    if (uri.indexOf(urnScheme) != 0 || uri[urnScheme.length] != ":")
      throw ("Invalid LNDConnect URI");
    return LNDConnectInfo(uri: Uri.parse(uri));
  }

  static String encode(LNDConnectInfo info) {
    String urnScheme = "lndconnect";
    var query = Uri(queryParameters: {
      "cert": info.uri.queryParameters["cert"],
      "macaroon": info.uri.queryParameters["macaroon"],
    }).toString();
    return "$urnScheme://${info.address}$query";
  }
}
