import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class NodeInfoBloc extends LightningBloc {
  GetInfoResponse _nodeInfo;

  final _nodeInfoSubject = BehaviorSubject<GetInfoResponse>();
  Stream get nodeInfo => _nodeInfoSubject.stream;

  NodeInfoBloc() {
    _getInfo();
  }

  void _getInfo() async {
    _nodeInfo = await lightning.client.getInfo(GetInfoRequest());
    _nodeInfoSubject.add(_nodeInfo);
  }

  @override
  void dispose() {
    _nodeInfoSubject.close();
  }
}
