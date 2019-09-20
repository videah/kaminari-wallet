import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:grpc/grpc.dart';
import 'package:hive/hive.dart';
import 'package:kaminari_wallet/generated/lnd/lnrpc/rpc.pbgrpc.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';

class LightningSingleton {
  LightningClient client;
  static final LightningSingleton _singleton = LightningSingleton._internal();

  factory LightningSingleton() => _singleton;

  LightningSingleton._internal();

  Future initialize() async {
    final storage = Hive.box("lndconnect");
    final settings = await storage.get("lndconnect-string");
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
