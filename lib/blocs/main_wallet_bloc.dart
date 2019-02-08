import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class MainWalletBloc extends LightningBloc {
  String _balance;
  List<Transaction> _transactions;

  final _balanceSubject = BehaviorSubject<String>(seedValue: "0 sat");
  Stream get balance => _balanceSubject.stream;

  final _transactionSubject = BehaviorSubject<List<Transaction>>();
  Stream get transactions => _transactionSubject.stream;

  MainWalletBloc() {
    _setup();
  }

  void _setup() async {
    await lightning.initialize();
    _syncBalance();
    _syncTransactions();
    lightning.client
        .subscribeTransactions(GetTransactionsRequest())
        .listen((tx) {
      _syncTransactions();
    });
  }

  void _syncBalance() async {
    var response = await lightning.client.walletBalance(
      WalletBalanceRequest(),
    );
    _balance = response.confirmedBalance.toString();
    _balanceSubject.add("$_balance sat");
  }

  void _syncTransactions() async {
    var response = await lightning.client.getTransactions(
      GetTransactionsRequest(),
    );
    _transactions = response.transactions;
    _transactionSubject.add(_transactions);
  }

  @override
  void dispose() {
    _balanceSubject.close();
    _transactionSubject.close();
    lightning.client.closeChannel(CloseChannelRequest());
  }
}
