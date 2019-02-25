import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/pages/wallet/transaction_detail_page.dart';
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
      child: StreamBuilder<List<dynamic>>(
        stream: bloc.history,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _transactions = snapshot.data;
            return AnimatedList(
              key: _listKey,
              initialItemCount: _transactions.length,
              itemBuilder: (context, index, animation) {
                if (_transactions[index] is HistoryItem) {
                  HistoryItem tx = _transactions[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: StreamBuilder<Map<String, String>>(
                        stream: BlocProvider.of<MainWalletBloc>(context).names,
                        builder: (context, snapshot) {
                          var name;
                          if (snapshot.hasData) name = snapshot.data[tx.userId];
                          return Column(
                            children: <Widget>[
                              _transactions[index - 1] is HistoryHeaderItem ? Container() : Divider(height: 0.0,),
                              TransactionTile(
                                title: name != null ? "$name" : tx.name,
                                subtitle: Text("${tx.memo}"),
                                userId: tx.userId,
                                amount: tx.amount,
                                direction: tx.direction,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionDetailPage(tx: tx),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, bottom: 0.0),
                    child: Text("${_transactions[index].date}"),
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
