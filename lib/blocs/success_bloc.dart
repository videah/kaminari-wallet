import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:hive/hive.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';

class SuccessBloc extends Bloc {
  final LNDConnectInfo lndOptions;

  SuccessBloc(this.lndOptions) {
    var storage = Hive.box("lndconnect");
    storage.put("lndconnect-string", lndOptions.toString());
  }

  @override
  void dispose() {}
}
