import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class MainWalletBloc extends LightningBloc {
  String _balance;
  List<Transaction> _transactions;
  List<Payment> _payments;
  List<dynamic> _history = [];
  List<Invoice> _invoices;

  final _balanceSubject = BehaviorSubject<String>(seedValue: "0 sat");
  Stream get balance => _balanceSubject.stream;

  final _transactionSubject = BehaviorSubject<List<Transaction>>();
  Stream get transactions => _transactionSubject.stream;

  final _historySubject = BehaviorSubject<List<dynamic>>();
  Stream get history => _historySubject.stream;

  final _invoicesSubject = BehaviorSubject<List<Invoice>>();
  Stream get invoices => _invoicesSubject.stream;

  final _newTransactionSubject = BehaviorSubject();
  Stream get newTransaction => _newTransactionSubject.stream;

  MainWalletBloc() {
    _setup();
  }

  void _setup() async {
    await lightning.initialize();
    _syncBalance();
    await _syncTransactions();
    await _syncPayments();
    await _sortHistory();
    await _syncInvoices();
    lightning.client
        .subscribeTransactions(GetTransactionsRequest())
        .listen(_newTransactionSubject.add);
  }

  void _syncBalance() async {
    var response = await lightning.client.walletBalance(
      WalletBalanceRequest(),
    );
    _balance = response.confirmedBalance.toString();
    _balanceSubject.add("$_balance sat");
  }

  Future _syncTransactions() async {
    var response = await lightning.client.getTransactions(
      GetTransactionsRequest(),
    );
    _transactions = response.transactions.toList();
    _history.addAll(_transactions);
    _transactionSubject.add(_transactions);
  }

  Future _syncPayments() async {
    var response = await lightning.client.listPayments(ListPaymentsRequest());
    _payments = response.payments.toList();
    _history.addAll(_payments);
  }

  Future _sortHistory() async {
    _history.sort((a, b) {
      var aTimestamp = a is Transaction
          ? a.timeStamp
          : a is Invoice ? a.creationDate : a.creationDate;
      var bTimestamp = b is Transaction
          ? b.timeStamp
          : b is Invoice ? b.creationDate : b.creationDate;
      return aTimestamp < bTimestamp ? 1 : aTimestamp > bTimestamp ? -1 : 0;
    });
    _historySubject.add(_history);
  }

  Future _syncInvoices() async {
    var response = await lightning.client.listInvoices(ListInvoiceRequest());
    _invoices = response.invoices.toList();
    _invoicesSubject.add(_invoices);
  }

  @override
  void dispose() {
    _balanceSubject.close();
    _transactionSubject.close();
    _historySubject.close();
    _invoicesSubject.close();
    _newTransactionSubject.close();
    lightning.client.closeChannel(CloseChannelRequest());
  }
}
