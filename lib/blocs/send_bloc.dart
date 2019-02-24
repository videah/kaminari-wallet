import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class SendBloc extends LightningBloc {

  final String requestString;
  PayReq _request;
  NodeInfo _destination;

  final _requestSubject = BehaviorSubject<PayReq>();
  Stream get request => _requestSubject.stream;

  final _destinationSubject = BehaviorSubject<NodeInfo>();
  Stream get destination => _destinationSubject.stream;

  SendBloc(this.requestString) {
    _setup();
  }

  void _setup() async {
    await _decodeRequest();
    await _getDestinationInfo();
  }

  Future _decodeRequest() async {
    var invoice = PayReqString();
    invoice.payReq = requestString;
    _request = await lightning.client.decodePayReq(invoice);
    _requestSubject.add(_request);
  }

  Future _getDestinationInfo() async {
    try {
      var request = NodeInfoRequest();
      request.pubKey = _request.destination;
      _destination = await lightning.client.getNodeInfo(request);
      _destinationSubject.add(_destination);
    } catch(e) {
      _destinationSubject.addError(e);
    }
  }

  @override
  void dispose() {
    _requestSubject.close();
    _destinationSubject.close();
  }

}