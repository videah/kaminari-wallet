import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

class InvoicesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MainWalletBloc>(context);
    return RefreshIndicator(
      onRefresh: () async {},
      child: StreamBuilder<List<Invoice>>(
        stream: bloc.invoices,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var invoice = snapshot.data[index];
                  return ListTile(
                    title: Text("Invoice"),
                    subtitle: Text("${invoice.memo}"),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No Invoices"),
              );
            }
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
