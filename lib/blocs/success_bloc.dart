import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';
import 'package:rxdart/rxdart.dart';

class SuccessBloc extends Bloc {
  final LNDConnectInfo lndOptions;

  SuccessBloc(this.lndOptions);

  @override
  void dispose() {
  }

}