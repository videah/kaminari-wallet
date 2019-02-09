import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

class TransactionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MainWalletBloc>(context);
    return RefreshIndicator(
      onRefresh: () async {},
      child: StreamBuilder<List<dynamic>>(
        stream: bloc.history,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                if (snapshot.data[index] is Transaction) {
                  Transaction tx = snapshot.data[index];
                  return TransactionTile(
                    title: Text(
                      "Anonymous",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Chain Transaction"),
                    amount: tx.amount.toInt(),
                    direction: tx.amount < 0
                        ? TxDirection.sending
                        : TxDirection.receiving,
                    image: NetworkImage(
                      "https://pbs.twimg.com/profile_images/941678006606729217/C4L6sQEf_400x400.jpg",
                    ),
                  );
                } else if (snapshot.data[index] is Payment) {
                  Payment tx = snapshot.data[index];
                  return TransactionTile(
                    title: Text(
                      "Anonymous",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Lightning Transaction"),
                    amount: tx.value.toInt(),
                    direction: TxDirection.sending,
                    image: NetworkImage(
                      "https://pbs.twimg.com/profile_images/941678006606729217/C4L6sQEf_400x400.jpg",
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
