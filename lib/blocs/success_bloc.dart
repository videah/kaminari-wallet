import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SuccessBloc extends Bloc {
  final LNDConnectInfo lndOptions;

  SuccessBloc(this.lndOptions) {
    var storage = FlutterSecureStorage();
    storage.write(key: "lndconnect", value: lndOptions.toString());
  }

  @override
  void dispose() {}
}
