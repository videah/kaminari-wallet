String formatCertificateString(cert) {
  var formattedCert = "-----BEGIN CERTIFICATE-----\n";
  var max = (cert.length / 64).floor();
  for (var i = 0; i < max; i++) {
    var start = (i * 64);
    var end = ((i + 1) * 64);
    formattedCert += "${cert.substring(start, end)}\n";
    if (i == max - 1) {
      formattedCert += "${cert.substring(end)}\n";
    }
  }
  formattedCert += "-----END CERTIFICATE-----";
  return formattedCert;
}

String base64UrlToBase64(String base64) {
  base64 = base64.replaceAll("-", "+");
  base64 = base64.replaceAll("_", "/");
  if (base64.length % 4 != 0) {
    base64 = base64.padRight(4 - base64.length % 4, "=");
  }
  return base64;
}
