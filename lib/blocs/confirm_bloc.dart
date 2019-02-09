import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:grpc/grpc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';
import 'package:rxdart/rxdart.dart';

class ConfirmBloc extends Bloc {
  LightningClient lnd;
  final LNDConnectInfo lndOptions;

  GetInfoResponse _nodeInfo;

  final _infoSubject = BehaviorSubject();
  Stream get info => _infoSubject.stream;

  final _statusStream = StreamController();
  Stream get status => _statusStream.stream;

  void _setupLND() {

    final certificate = utf8.encode(lndOptions.cert);
    final macaroon = hex.encode(base64.decode(lndOptions.macaroon));

    final Map<String, String> metadata = {"macaroon": macaroon};

    lnd = LightningClient(
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

  void _getInfoFromNode() async {
    try {
      var response = await lnd.getInfo(GetInfoRequest());
      _nodeInfo = response;
      _infoSubject.add(_nodeInfo);
    } catch (e) {
      _statusStream.add(e);
    }
  }

  ConfirmBloc(this.lndOptions) {
    _setupLND();
    _getInfoFromNode();
  }

  @override
  void dispose() {
    _infoSubject.close();
    _statusStream.close();
    lnd.closeChannel(CloseChannelRequest());
  }
}
