import 'dart:async';

import 'package:convert/convert.dart';
import 'package:kaminari_wallet/blocs/lightning_bloc.dart';
import 'package:kaminari_wallet/generated/lnd/lnrpc/rpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';
import 'package:rxdart/rxdart.dart';

class MainWalletBloc extends LightningBloc {

  // Wallet
  String _balance;
  List<Transaction> _transactions;
  List<Payment> _payments;
  List<Invoice> _invoices;
  List<HistoryItem> _history = [];
  Map<String, String> _nameCache = {};
  Map<String, String> _descriptionCache = {};

  // Info
  GetInfoResponse _nodeInfo;

  final _nodeInfoSubject = BehaviorSubject<GetInfoResponse>();
  Stream get nodeInfo => _nodeInfoSubject.stream;

  final _balanceSubject = BehaviorSubject<String>();
  Stream get balance => _balanceSubject.stream;

  final _transactionSubject = BehaviorSubject<List<Transaction>>();
  Stream get transactions => _transactionSubject.stream;

  final _historySubject = BehaviorSubject<List<HistoryItem>>();
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
    setup();
  }

  void setup() async {
    await initLightning();
    await syncWithNode();
    await setupSubscriptions();
  }

  Future syncWithNode() async {
    await _getNodeInfo();
    await _syncBalance();
    await _syncTransactions();
    await _syncPayments();
    await _syncInvoices();
    await _sortHistory();
    await _syncNames();
  }

  Future setupSubscriptions() async {
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

  Future initLightning() async {
    await lightning.initialize();
  }

  Future<String> getNameFromPubKey(String pub) async {
    if (!_nameCache.containsKey(pub)) {
      var request = NodeInfoRequest();
      request.pubKey = pub;
      var response = await lightning.client.getNodeInfo(request);
      var alias = response.node.alias;
      _nameCache.addAll(
        {
          pub: alias.isNotEmpty ? alias : "Unknown Node",
        },
      );
    }
    return _nameCache[pub];
  }
  
  Future<String> getDescriptionFromInvoice(String invoice) async {
    if (!_descriptionCache.containsKey(invoice)) {
      var request = PayReqString();
      request.payReq = invoice;
      var response = await lightning.client.decodePayReq(request);
      var description = response.description;
      _descriptionCache.addAll(
        {
          invoice: description.isNotEmpty ? description : "Lightning Payment"
        }
      );
    }
    return _descriptionCache[invoice];
  }

  GetInfoResponse getNodeInfo() {
    return _nodeInfo;
  }

  void _handleNewInvoice(Invoice invoice) async {
    if (invoice.hasSettleDate()) {
      var invoiceItem = HistoryItem(
        name: "Anonymous",
        memo: invoice.memo,
        amount: invoice.value.toInt(),
        timestamp: invoice.creationDate.toInt(),
        direction: TxStatus.receiving,
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
      direction: tx.amount > 0 ? TxStatus.receiving : TxStatus.sending,
      confirmations: tx.numConfirmations,
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
        direction: TxStatus.sending,
        receipt: tx.paymentPreimage,
        route: tx.path,
      );
      _newTransactionSubject.add(paymentItem);
    }
  }

  Future _syncBalance() async {
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
          confirmations: tx.numConfirmations,
          direction: tx.amount > 0 ? TxStatus.receiving : TxStatus.sending,
        ),
      ),
    );
    _history.addAll(_historyItems);
  }

  Future _syncPayments() async {
    var response = await lightning.client.listPayments(ListPaymentsRequest());
    _payments = response.payments.toList();
    List<HistoryItem> _historyItems = [];
    for (var tx in _payments) {
      var memo = await getDescriptionFromInvoice(tx.paymentRequest);
      _historyItems.add(
        HistoryItem(
          name: "Unknown",
          memo: memo,
          amount: tx.valueSat.toInt(),
          userId: tx.path.last,
          timestamp: tx.creationDate.toInt(),
          direction: TxStatus.sending,
          receipt: tx.paymentPreimage,
          route: tx.path,
        ),
      );
    }
    _history.addAll(_historyItems);
  }

  Future _syncInvoices() async {
    var response = await lightning.client.listInvoices(ListInvoiceRequest());
    _invoices = response.invoices.toList();
    _invoicesSubject.add(_invoices);

    List<HistoryItem> _historyItems = [];
    _invoices.where((invoice) => invoice.hasSettleDate()).forEach(
          (tx) => _historyItems.add(
            HistoryItem(
              name: "Anonymous",
              memo: tx.memo,
              amount: tx.value.toInt(),
              timestamp: tx.creationDate.toInt(),
              direction: TxStatus.receiving,
              receipt: hex.encode(tx.rPreimage),
            ),
          ),
        );
    _history.addAll(_historyItems);
  }

  Future _syncNames() async {
    for (var payment in _payments) {
      getNameFromPubKey(payment.path.last);
    }
    _namesSubject.add(_nameCache);
  }

  Future _sortHistory() async {
    _history.sort((a, b) {
      return a.timestamp < b.timestamp ? 1 : a.timestamp > b.timestamp ? -1 : 0;
    });
    _historySubject.add(_history);
  }

  Future _getNodeInfo() async {
    _nodeInfo = await lightning.client.getInfo(GetInfoRequest());
    _nodeInfoSubject.add(_nodeInfo);
  }

  @override
  void dispose() {
//    _balanceSubject.close();
//    _transactionSubject.close();
//    _historySubject.close();
//    _invoicesSubject.close();
//    _newTransactionSubject.close();
//    _namesSubject.close();
//    _syncController.close();

    _balance = null;
    _balanceSubject.add("");
    _transactions.clear();
    _payments.clear();
    _invoices.clear();
    _history.clear();
    _nameCache.clear();
  }
}

class HistoryItem {
  final String name;
  final String memo;
  final int amount;
  final int timestamp;
  final String userId;
  final TxStatus direction;
  final String receipt;
  final List<String> route;
  final int confirmations;

  HistoryItem({
    this.direction,
    this.name,
    this.memo,
    this.amount,
    this.timestamp,
    this.userId,
    this.receipt,
    this.route,
    this.confirmations,
  });
}
