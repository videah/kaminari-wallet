import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';

class LightningSingleton {
  LightningClient client;
  static final LightningSingleton _singleton = LightningSingleton._internal();

  factory LightningSingleton() => _singleton;

  LightningSingleton._internal();

  Future initialize() async {
    final storage = FlutterSecureStorage();
    final settings = await storage.read(key: "lndconnect");
    final lndOptions = LNDConnect.decode(settings);

    final certificate = utf8.encode(lndOptions.cert);
    final macaroon = hex.encode(base64.decode(lndOptions.macaroon));

    final Map<String, String> metadata = {"macaroon": macaroon};

    client = LightningClient(
      ClientChannel(
        lndOptions.host,
        port: lndOptions.port,
        options: ChannelOptions(
          credentials: ChannelCredentials.secure(
            certificates: certificate,
            // TODO: This is temporary, remove before release.
            onBadCertificate: (cert, host) {
              return true;
            },
          ),
        ),
      ),
      options: CallOptions(metadata: metadata),
    );
  }
}
