import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:rxdart/rxdart.dart';

// This is just a convenient class that auto-reconnects the client
// It's a bit messy and it won't work on desktop.
// TODO: Replace this.

class ConvenientLightningClient extends LightningClient {
  final CallOptions _options;
  final Connectivity _connectivity;
  ClientChannel _channel;
  bool hasRecentlyFailed = false;

  ConvenientLightningClient(this._connectivity, this._channel,
      {CallOptions options})
      : _options = options ?? CallOptions(),
        super(_channel) {
    _connectivity.onConnectivityChanged.listen(
      (result) {
        if (hasRecentlyFailed && result != ConnectivityResult.none) {
          _restoreChannel();
        }
      },
    );
  }

  _restoreChannel() {
    _channel = ClientChannel(_channel.host,
        port: _channel.port, options: _channel.options);
    hasRecentlyFailed = false;
  }

  @override
  ClientCall<Q, R> $createCall<Q, R>(
      ClientMethod<Q, R> method, Stream<Q> requests,
      {CallOptions options}) {
    BroadcastCall<Q, R> call = createChannelCall(
      method,
      requests,
      _options.mergedWith(options),
    );
    call.response.listen(
      (_) {},
      onError: (Object error) async {
        if (error is GrpcError && error.code == StatusCode.unavailable) {
          _connectivity.checkConnectivity().then(
            (result) {
              if (result != ConnectivityResult.none) _restoreChannel();
            },
          );
          hasRecentlyFailed = true;
        }
      },
    );
    return call;
  }

  /// Initiates a new RPC on this connection.
  /// This is copy of [ClientChannel.createCall]
  /// The only difference is that it creates [BroadcastCall] instead of [ClientCall]
  ClientCall<Q, R> createChannelCall<Q, R>(
      ClientMethod<Q, R> method, Stream<Q> requests, CallOptions options) {
    final call = new BroadcastCall(method, requests, options);
    _channel.getConnection().then((connection) {
      if (call.isCancelled) return;
      connection.dispatchCall(call);
    }, onError: call.onConnectionError);
    return call;
  }
}

// A ClientCall that can be listened multiple times
class BroadcastCall<Q, R> extends ClientCall<Q, R> {
  BehaviorSubject<R> subject = BehaviorSubject<R>();

  BroadcastCall(
      ClientMethod<Q, R> method, Stream<Q> requests, CallOptions options)
      : super(method, requests, options) {
    super.response.listen(
          (data) => subject.add(data),
          onError: (error) => subject.addError(error),
          onDone: () => subject.close(),
        );
  }

  @override
  Stream<R> get response => subject.stream;
}
