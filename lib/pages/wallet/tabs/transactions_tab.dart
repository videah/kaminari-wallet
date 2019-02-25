import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

class TransactionsTab extends StatefulWidget {
  @override
  TransactionsTabState createState() {
    return new TransactionsTabState();
  }
}

List<dynamic> _transactions = [];

class TransactionsTabState extends State<TransactionsTab> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10)).then((_) {
      var bloc = BlocProvider.of<MainWalletBloc>(context);
      bloc.newTransaction.listen(_addTransaction);
    });
  }

  void _addTransaction(var tx) {
    _transactions.insert(0, tx);
    _listKey.currentState.insertItem(0, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MainWalletBloc>(context);
    return RefreshIndicator(
      onRefresh: () async {},
      child: StreamBuilder<Object>(
        stream: bloc.history,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _transactions = snapshot.data;
            return AnimatedList(
              key: _listKey,
              initialItemCount: _transactions.length,
              itemBuilder: (context, index, animation) {
                if (_transactions[index] is Transaction) {
                  Transaction tx = _transactions[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: TransactionTile(
                        title: "Anonymous",
                        subtitle: Text("Chain Transaction"),
                        amount: tx.amount.toInt(),
                        direction: tx.amount < 0
                            ? TxDirection.sending
                            : TxDirection.receiving,
                      ),
                    ),
                  );
                } else if (_transactions[index] is Payment) {
                  Payment tx = _transactions[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: StreamBuilder<Map<String, String>>(
                        stream: BlocProvider.of<MainWalletBloc>(context).names,
                        builder: (context, snapshot) {
                          var name;
                          if (snapshot.hasData)
                            name = snapshot.data[tx.path.last];
                          return TransactionTile(
                            title: name != null ? "$name" : "Unknown Node",
                            subtitle: Text("Lightning Transaction"),
                            userId: tx.path.last,
                            amount: tx.value.toInt(),
                            direction: TxDirection.sending,
                          );
                        },
                      ),
                    ),
                  );
                } else if (_transactions[index] is Invoice) {
                  Invoice tx = _transactions[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: TransactionTile(
                        title: "Anonymous",
                        subtitle: Text(
                          tx.memo.isNotEmpty
                              ? tx.memo
                              : "Lightning Transaction",
                        ),
                        amount: tx.amtPaidSat.toInt(),
                        direction: TxDirection.receiving,
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
