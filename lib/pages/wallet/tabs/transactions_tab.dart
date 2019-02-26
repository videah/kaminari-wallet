import 'dart:async';

import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/pages/wallet/transaction_detail_page.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

class TransactionsTab extends StatefulWidget {
  @override
  TransactionsTabState createState() {
    return new TransactionsTabState();
  }
}

class TransactionsTabState extends State<TransactionsTab> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<dynamic> _transactions = [];
  StreamSubscription _syncSubscription;

  @override
  void initState() {
    super.initState();
    // This has a weird race condition on profile/release mode
    // TODO: Fix this
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      var bloc = BlocProvider.of<MainWalletBloc>(context);
      _syncSubscription = bloc.newTransaction.listen(_addTransaction);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _syncSubscription.cancel();
  }

  void _addTransaction(var tx) {
    _transactions.insert(0, tx);
    _listKey.currentState.insertItem(0, duration: Duration(milliseconds: 300));
  }

  Widget _buildTimestamp(BuildContext context, timestamp) {
    var date = _getDate(timestamp);
    var prettyDate = DateFormat.yMMMd().format(date);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 0.0),
      child: Text("$prettyDate"),
    );
  }

  DateTime _getDate(timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MainWalletBloc>(context);
    return RefreshIndicator(
      onRefresh: () async {
        bloc.sync.add(true);
      },
      child: StreamBuilder<List<dynamic>>(
        stream: bloc.history,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _transactions = snapshot.data;
            return AnimatedList(
              key: _listKey,
              initialItemCount: _transactions.length,
              itemBuilder: (context, index, animation) {
                HistoryItem tx = _transactions[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        if (index != 0) {
                          var day = _getDate(tx.timestamp).day;
                          var nextDay = _getDate(_transactions[index - 1].timestamp).day;
                          return day < nextDay
                              ? _buildTimestamp(context, tx.timestamp)
                              : Divider(
                                  height: 0.0,
                                );
                        } else {
                          return _buildTimestamp(context, tx.timestamp);
                        }
                      },
                    ),
                    SizeTransition(
                      sizeFactor: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: StreamBuilder<Map<String, String>>(
                          stream:
                              BlocProvider.of<MainWalletBloc>(context).names,
                          builder: (context, snapshot) {
                            var name;
                            if (snapshot.hasData)
                              name = snapshot.data[tx.userId];
                            return TransactionTile(
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
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
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
