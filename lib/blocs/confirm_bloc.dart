import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:grpc/grpc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/utils/certificate.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';
import 'package:rxdart/rxdart.dart';

class ConfirmBloc extends Bloc {
  LightningClient lnd;
  final LNDConnectInfo lndOptions;

  GetInfoResponse _nodeInfo;

  final _infoSubject = BehaviorSubject();
  Stream get info => _infoSubject.stream;

  void _setupLND() {
    final decodedCert = base64UrlToBase64(lndOptions.cert);
    final formattedCert = formatCertificateString(decodedCert);
    final certificate = utf8.encode(formattedCert);
    final b64Mac = base64Url.decode(lndOptions.macaroon);
    final macaroon = hex.encode(b64Mac);

    final Map<String, String> metadata = {"macaroon": macaroon};

    lnd = LightningClient(
      ClientChannel(
          lndOptions.host,
          port: lndOptions.port,
          options: ChannelOptions(
              credentials: ChannelCredentials.secure(
                certificates: certificate,
                onBadCertificate: (cert, host) {
                  return true;
                },
              )
          )
      ),
      options: CallOptions(metadata: metadata),
    );
  }

  void _getInfoFromNode() async {
    var response = await lnd.getInfo(GetInfoRequest());
    _nodeInfo = response;
    _infoSubject.add(_nodeInfo);
  }

  ConfirmBloc(this.lndOptions) {
    _setupLND();
    _getInfoFromNode();
  }

  @override
  void dispose() {
    _infoSubject.close();
    lnd.closeChannel(CloseChannelRequest());
  }
}
