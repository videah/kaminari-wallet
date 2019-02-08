import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';

class MainWalletBloc extends LightningBloc {

  MainWalletBloc() {
    test();
  }

  void test() async {
    await lightning.initialize();
    print(await lightning.client.walletBalance(WalletBalanceRequest()));
  }

  @override
  void dispose() {
    lightning.client.closeChannel(CloseChannelRequest());
  }
}