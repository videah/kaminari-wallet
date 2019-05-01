import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/wallet/invoice_tile.dart';

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
                  Invoice invoice = snapshot.data[index];
                  return InvoiceTile(
                    name: "Invoice",
                    description: invoice.memo,
                    amount: invoice.value.toInt(),
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
