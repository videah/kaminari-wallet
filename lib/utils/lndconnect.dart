class LNDConnectInfo {
  final Uri uri;

  get host => uri.host;
  get port => uri.port;
  get address => "${uri.host}:${uri.port}";
  get cert => uri.queryParameters["cert"];
  get macaroon => uri.queryParameters["macaroon"];

  LNDConnectInfo({this.uri});
}

class LNDConnect {
  static LNDConnectInfo decode(String uri) {
    String urnScheme = "lndconnect";
    if (uri.indexOf(urnScheme) != 0 || uri[urnScheme.length] != ":")
      throw ("Invalid LNDConnect URI");
    return LNDConnectInfo(uri: Uri.parse(uri));
  }
}
