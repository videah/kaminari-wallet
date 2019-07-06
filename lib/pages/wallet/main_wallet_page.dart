import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/pages/settings/settings_page.dart';
import 'package:kaminari_wallet/pages/wallet/transaction_detail_page.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';
import 'package:kaminari_wallet/widgets/wallet/receive_modal.dart';
import 'package:kaminari_wallet/widgets/wallet/send_modal.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';
import 'package:sliver_fill_remaining_box_adapter/sliver_fill_remaining_box_adapter.dart';

class MainWalletPage extends StatelessWidget {

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

  Widget _buildTile(BuildContext context, HistoryItem tx) {
    return StreamBuilder<Map<String, String>>(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MainWalletBloc>(context);
    var _previousTx;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 200.0,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: StreamBuilder<String>(
                stream: bloc.balance,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data}",
                      style: TextStyle(fontSize: 24.0),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
          StreamBuilder<List<HistoryItem>>(
              stream: bloc.history,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverFillRemainingBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    HistoryItem tx = snapshot.data[i];
                    var divider = _buildDivider(tx, _previousTx, i);
                    var tile = _buildTile(context, tx);
                    _previousTx = tx;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        divider,
                        tile,
                      ],
                    );
                  }, childCount: snapshot.data.length),
                );
              })
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            height: 0.0,
          ),
          BottomButtonBar(
            children: <Widget>[
              FillIconButton(
                icon: Icon(Icons.call_received),
                child: Text("Receive"),
                onTap: () {
                  showModalBottomSheet(
                    context: (context),
                    builder: (context) {
                      return ReceiveModal();
                    },
                  );
                },
              ),
              FillIconButton(
                icon: Icon(Icons.call_made),
                child: Text("Send"),
                onTap: () {
                  showModalBottomSheet(
                    context: (context),
                    builder: (context) {
                      return SendModal();
                    },
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
