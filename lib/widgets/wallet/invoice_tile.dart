import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaminari_wallet/widgets/wallet/amount_label.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

class InvoiceTile extends StatelessWidget {
  final String name;
  final String description;
  final int amount;

  const InvoiceTile({Key key, this.name, this.description, this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${name ?? "Unknown"}"),
      subtitle: Text("${description ?? "No Description"}"),
      leading: CircleAvatar(
        child: Icon(FontAwesomeIcons.fileInvoice),
      ),
      trailing: AmountLabel(
        text: amount.toString(),
        direction: TxStatus.pending,
      ),
    );
  }
}
