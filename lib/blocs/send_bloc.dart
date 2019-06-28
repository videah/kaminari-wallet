import 'dart:async';

import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/lnd/lnrpc/rpc.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class SendBloc extends LightningBloc {

  final String requestString;
  PayReq _request;
  NodeInfo _destination;
  GetInfoResponse _node;

  bool attemptingSend = false;

  final _requestSubject = BehaviorSubject<PayReq>();
  Stream get request => _requestSubject.stream;

  final _selfSubject = BehaviorSubject<GetInfoResponse>();
  Stream get node => _selfSubject.stream;

  final _destinationSubject = BehaviorSubject<NodeInfo>();
  Stream get destination => _destinationSubject.stream;

  final _sendAttemptSubject = BehaviorSubject<bool>();
  Stream get attempting => _sendAttemptSubject.stream;

  final _paymentResultSubject = BehaviorSubject<SendResponse>();
  Stream get result => _paymentResultSubject.stream;

  final _startAttemptController = StreamController<bool>();
  Sink<bool> get startAttempt => _sendAttemptSubject.sink;

  SendBloc(this.requestString) {
    _sendAttemptSubject.stream.listen((_) => _attemptPayment());
    _setup();
  }

  void _setup() async {
    await _decodeRequest();
    await _getSelfNodeInfo();
    await _getDestinationInfo();
  }

  Future _decodeRequest() async {
    var invoice = PayReqString();
    invoice.payReq = requestString;
    _request = await lightning.client.decodePayReq(invoice);
    _requestSubject.add(_request);
  }

  Future _getSelfNodeInfo() async {
    _node = await lightning.client.getInfo(GetInfoRequest());
    _selfSubject.add(_node);
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

  Future _attemptPayment() async {
    print("test");
    try {
      var request = SendRequest();
      request.paymentRequest = requestString;
      var response = await lightning.client.sendPaymentSync(request);
      _paymentResultSubject.add(response);
    } catch(e) {
      _paymentResultSubject.addError(e);
    }
  }

  @override
  void dispose() {
    _requestSubject.close();
    _destinationSubject.close();
    _selfSubject.close();
    _sendAttemptSubject.close();
    _startAttemptController.close();
  }

}