import 'dart:async';

import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/pages/wallet/transaction_detail_page.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';
import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:date_util/date_util.dart';

class TransactionsTab extends StatelessWidget {
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

  Widget _buildDivider(HistoryItem tx, HistoryItem previousTx, int index) {
    return Builder(
      builder: (context) {
        if (index != 0) {
          var date = _getDate(tx.timestamp);
          var prevDate = _getDate(previousTx.timestamp);

          var day =
              DateUtil().totalLengthOfDays(date.month, date.day, date.year);
          var prevDay = DateUtil()
              .totalLengthOfDays(prevDate.month, prevDate.day, prevDate.year);
          return day < prevDay
              ? _buildTimestamp(context, tx.timestamp)
              : Divider(height: 0.0);
        } else {
          return _buildTimestamp(context, tx.timestamp);
        }
      },
    );
  }

  Widget _buildTile(
      BuildContext context, HistoryItem tx, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: StreamBuilder<Map<String, String>>(
          stream: BlocProvider.of<MainWalletBloc>(context).names,
          builder: (context, snapshot) {
            var name;
            if (snapshot.hasData) name = snapshot.data[tx.userId];
            return TransactionTile(
              title: name != null ? "$name" : tx.name,
              subtitle: Text("${tx.memo}"),
              userId: tx.userId,
              amount: tx.amount,
              direction: tx.direction,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailPage(tx: tx),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MainWalletBloc>(context);
    final Stream<List<HistoryItem>> history = bloc.history.cast();
    var _previousTx;
    return RefreshIndicator(
      onRefresh: () async {
        bloc.sync.add(true);
      },
      child: StreamBuilder<Object>(
        stream: bloc.history,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return AnimatedStreamList<HistoryItem>(
            streamList: history,
            itemBuilder: (tx, index, context, animation) {
              var divider = _buildDivider(tx, _previousTx, index);
              var tile = _buildTile(context, tx, animation);
              _previousTx = tx;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  divider,
                  tile,
                ],
              );
            },
            itemRemovedBuilder: (tx, index, context, animation) {},
          );
        },
      ),
    );
  }
}
