import 'dart:io' show Platform;
import 'dart:convert';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

enum InitialRoute { home, setup }

class InitialRoutingBloc extends Bloc {
  InitialRoute _route;

  final _routingSubject = BehaviorSubject<InitialRoute>();
  Stream get route => _routingSubject.stream;

  InitialRoutingBloc() {
    _checkForInitialRoute();
  }

  Future _initializeBoxes() async {
    // Generating and storing a secure key, used to securely store
    // data required to connect and authenticate with an LND instance.
    var key;
    if (Platform.isFuchsia) {
      // We use SharedPreferences on desktop, since there's no plugin to do
      // that using the OS's keystore yet. This shouldn't be a problem though.
      print("We're on desktop");
      var keystore = await SharedPreferences.getInstance();
      var read = keystore.getString("hive-key");
      key = read ?? base64.encode(Hive.generateSecureKey());
      if (read == null) await keystore.setString("hive-key", key);
    } else {
      // On mobile we use the OS's secure keystore to store the key.
      print("We're on mobile");
      var keystore = FlutterSecureStorage();
      var read = await keystore.read(key: "hive-key");
      key = read ?? base64.encode(Hive.generateSecureKey());
      if (read == null) await keystore.write(key: "hive-key", value: key);
    }

    // We need a place to store the actual hivedb contents.
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    // Open some boxes to store data in.
    return Future.wait([
      Hive.openBox("lndconnect", encryptionKey: base64.decode(key)),
      Hive.openBox("settings", encryptionKey: base64.decode(key)),
    ]);
  }

  void _checkForInitialRoute() async {
    await _initializeBoxes();
    var storage = Hive.box("lndconnect");
    var settings = await storage.get("lndconnect-string");
    _route = settings != null ? InitialRoute.home : InitialRoute.setup;
    _routingSubject.add(_route);
  }

  @override
  void dispose() {
    _routingSubject.close();
  }
}
