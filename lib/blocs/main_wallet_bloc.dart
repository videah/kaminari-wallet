import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class MainWalletBloc extends LightningBloc {
  String _balance;
  List<Transaction> _transactions;
  List<Payment> _payments;
  List<Invoice> _invoices;
  List<dynamic> _history = [];
  Map<String, String> _nameCache = {};

  final _balanceSubject = BehaviorSubject<String>();
  Stream get balance => _balanceSubject.stream;

  final _transactionSubject = BehaviorSubject<List<Transaction>>();
  Stream get transactions => _transactionSubject.stream;

  final _historySubject = BehaviorSubject<List<dynamic>>();
  Stream get history => _historySubject.stream;

  final _invoicesSubject = BehaviorSubject<List<Invoice>>();
  Stream get invoices => _invoicesSubject.stream;

  final _namesSubject = BehaviorSubject<Map<String, String>>();
  Stream get names => _namesSubject.stream;

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
    await _syncInvoices();
    await _sortHistory();
    await _syncNames();
    lightning.client
        .subscribeTransactions(GetTransactionsRequest())
        .listen(_newTransactionSubject.add);
    lightning.client
        .subscribeInvoices((InvoiceSubscription()))
        .listen((invoice) {
      if (invoice.settled) {
        _newTransactionSubject.add(invoice);
        _syncBalance();
      }
    });
  }

  void _syncBalance() async {
    var chainResponse = await lightning.client.walletBalance(
      WalletBalanceRequest(),
    );
    var lightningResponse = await lightning.client.channelBalance(
      ChannelBalanceRequest(),
    );
    _balance =
        (chainResponse.totalBalance + lightningResponse.balance).toString();
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

  Future _syncInvoices() async {
    var response = await lightning.client.listInvoices(ListInvoiceRequest());
    _invoices = response.invoices.toList();
    _history.addAll(_invoices.where((invoice) => invoice.settled));
    _invoicesSubject.add(_invoices);
  }

  Future _syncNames() async {
    for (var payment in _payments) {
      if (!_nameCache.containsKey(payment.path.last)) {
        var request = NodeInfoRequest();
        request.pubKey = payment.path.last;
        var response = await lightning.client.getNodeInfo(request);
        _nameCache.addAll({payment.path.last: response.node.alias});
      }
    }
    _namesSubject.add(_nameCache);
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

  @override
  void dispose() {
    _balanceSubject.close();
    _transactionSubject.close();
    _historySubject.close();
    _invoicesSubject.close();
    _newTransactionSubject.close();
    _namesSubject.close();
    lightning.client.closeChannel(CloseChannelRequest());
  }
}
