import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/utils/lightning_singleton.dart';

class LightningBloc extends Bloc {
  LightningSingleton lightning = LightningSingleton();

  @override
  void dispose() {}
}
