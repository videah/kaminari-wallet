import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class MainWalletBloc extends LightningBloc {
  String _balance;

  final _balanceSubject = BehaviorSubject<String>(seedValue: "0 sat");
  Stream get balance => _balanceSubject.stream;

  MainWalletBloc() {
    _setup();
  }

  void _setup() async {
    await lightning.initialize();
    _syncBalance();
  }

  void _syncBalance() async {
    var response = await lightning.client.walletBalance(WalletBalanceRequest());
    _balance = response.confirmedBalance.toString();
    _balanceSubject.add("$_balance sat");
  }

  @override
  void dispose() {
    _balanceSubject.close();
    lightning.client.closeChannel(CloseChannelRequest());
  }
}
