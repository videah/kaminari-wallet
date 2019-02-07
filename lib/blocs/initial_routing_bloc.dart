import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

enum InitialRoute { home, setup }

class InitialRoutingBloc extends Bloc {

  InitialRoute _route;

  final _routingSubject = BehaviorSubject<InitialRoute>();
  Stream get route => _routingSubject.stream;

  InitialRoutingBloc() {
    _checkForInitialRoute();
  }

  void _checkForInitialRoute() async {
    var storage = FlutterSecureStorage();
    var settings = await storage.read(key: "lndconnect");
    _route = settings != null ? InitialRoute.home : InitialRoute.setup;
    _routingSubject.add(_route);
  }

  @override
  void dispose() {
    _routingSubject.close();
  }
}
