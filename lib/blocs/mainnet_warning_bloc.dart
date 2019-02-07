import 'dart:async';

import 'package:kaminari_wallet/utils/lndconnect.dart';
import 'package:rxdart/rxdart.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class MainnetWarningBloc extends Bloc {
  final LNDConnectInfo lndOptions;
  bool _understood = false;

  final _understoodSubject = BehaviorSubject<bool>(seedValue: false);
  Stream get understood => _understoodSubject.stream;

  final _understoodController = StreamController<bool>();
  Sink<bool> get checkbox => _understoodController.sink;

  void _handleCheckbox(bool value) {
    _understood = value;
    _understoodSubject.add(_understood);
  }

  MainnetWarningBloc(this.lndOptions) {
    _understoodController.stream.listen(_handleCheckbox);
  }

  @override
  void dispose() {
    _understoodSubject.close();
    _understoodController.close();
  }
}
