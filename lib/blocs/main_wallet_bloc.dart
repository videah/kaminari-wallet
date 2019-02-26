import 'dart:async';

import 'package:convert/convert.dart';
import 'package:intl/intl.dart';
import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';
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

  final _syncController = StreamController<bool>();
  Sink<bool> get sync => _syncController.sink;

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
    _syncController.stream.listen((_) async {
      await _syncNewPayments();
      await _syncNames();
    });
    lightning.client
        .subscribeTransactions(GetTransactionsRequest())
        .listen(_handleNewTransaction);
    lightning.client
        .subscribeInvoices((InvoiceSubscription()))
        .listen(_handleNewInvoice);
  }

  void _handleNewInvoice(Invoice invoice) async {
    if (invoice.settled) {
      var invoiceItem = HistoryItem(
        name: "Anonymous",
        memo: invoice.memo,
        amount: invoice.value.toInt(),
        timestamp: invoice.creationDate.toInt(),
        direction: TxDirection.receiving,
        receipt: hex.encode(invoice.rPreimage),
      );
      _newTransactionSubject.add(invoiceItem);
      _syncBalance();
    }
  }

  void _handleNewTransaction(Transaction tx) async {
    var transactionItem = HistoryItem(
      name: "Anonymous",
      memo: "Chain Transaction",
      amount: tx.amount.toInt(),
      timestamp: tx.timeStamp.toInt(),
      direction: tx.amount > 0 ? TxDirection.receiving : TxDirection.sending,
    );
    _newTransactionSubject.add(transactionItem);
    _syncBalance();
  }

  Future _syncNewPayments() async {
    var response = await lightning.client.listPayments(ListPaymentsRequest());
    var newPayments = response.payments;
    newPayments.removeWhere((payment) => _payments.contains(payment));
    for (var tx in newPayments) {
      _payments.add(tx);
      var paymentItem = HistoryItem(
        name: "Unknown",
        memo: "Lightning Transaction",
        amount: tx.valueSat.toInt(),
        userId: tx.path.last,
        timestamp: tx.creationDate.toInt(),
        direction: TxDirection.sending,
        receipt: tx.paymentPreimage,
        route: tx.path,
      );
      _newTransactionSubject.add(paymentItem);
    }
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
    _transactionSubject.add(_transactions);
    List<HistoryItem> _historyItems = [];
    _transactions.forEach(
      (tx) => _historyItems.add(
            HistoryItem(
              name: "Anonymous",
              memo: "Chain Transaction",
              amount: tx.amount.toInt(),
              timestamp: tx.timeStamp.toInt(),
              direction:
                  tx.amount > 0 ? TxDirection.receiving : TxDirection.sending,
            ),
          ),
    );
    _history.addAll(_historyItems);
  }

  Future _syncPayments() async {
    var response = await lightning.client.listPayments(ListPaymentsRequest());
    _payments = response.payments.toList();
    List<HistoryItem> _historyItems = [];
    _payments.forEach(
      (tx) => _historyItems.add(
            HistoryItem(
              name: "Unknown",
              memo: "Lightning Transaction",
              amount: tx.valueSat.toInt(),
              userId: tx.path.last,
              timestamp: tx.creationDate.toInt(),
              direction: TxDirection.sending,
              receipt: tx.paymentPreimage,
              route: tx.path,
            ),
          ),
    );
    _history.addAll(_historyItems);
  }

  Future _syncInvoices() async {
    var response = await lightning.client.listInvoices(ListInvoiceRequest());
    _invoices = response.invoices.toList();
    _invoicesSubject.add(_invoices);

    List<HistoryItem> _historyItems = [];
    _invoices.where((invoice) => invoice.settled).forEach(
          (tx) => _historyItems.add(
                HistoryItem(
                  name: "Anonymous",
                  memo: tx.memo,
                  amount: tx.value.toInt(),
                  timestamp: tx.creationDate.toInt(),
                  direction: TxDirection.receiving,
                  receipt: hex.encode(tx.rPreimage),
                ),
              ),
        );
    _history.addAll(_historyItems);
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
      return a.timestamp < b.timestamp ? 1 : a.timestamp > b.timestamp ? -1 : 0;
    });
    await _insertDateHeaders();
    _historySubject.add(_history);
  }

  Future _insertDateHeaders() async {
    Map<int, int> indexes = {};
    for (var i = _history.length - 1; i > 0; i--) {
      var timestamp = _history[i].timestamp * 1000;
      var prevTimestamp = _history[i - 1].timestamp * 1000;
      var day = DateTime.fromMillisecondsSinceEpoch(timestamp).day;
      var prevDay = DateTime.fromMillisecondsSinceEpoch(prevTimestamp).day;
      if (prevDay != day) indexes.addAll({i: timestamp});
    }
    indexes.forEach((index, timestamp) {
      var prettyDate = DateFormat.yMMMd().format(
        DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
      _history.insert(index, HistoryHeaderItem(prettyDate));
    });
    var timestamp = _history[0].timestamp * 1000;
    var time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedTime = DateFormat.yMMMd().format(time);
    _history.insert(0, HistoryHeaderItem(formattedTime));
  }

  @override
  void dispose() {
    _balanceSubject.close();
    _transactionSubject.close();
    _historySubject.close();
    _invoicesSubject.close();
    _newTransactionSubject.close();
    _namesSubject.close();
    _syncController.close();
    lightning.client.closeChannel(CloseChannelRequest());
  }
}

class HistoryItem {
  final String name;
  final String memo;
  final int amount;
  final int timestamp;
  final String userId;
  final TxDirection direction;
  final String receipt;
  final List<String> route;

  HistoryItem({
    this.direction,
    this.name,
    this.memo,
    this.amount,
    this.timestamp,
    this.userId,
    this.receipt,
    this.route,
  });
}

class HistoryHeaderItem {
  final String date;

  HistoryHeaderItem(this.date);
}
