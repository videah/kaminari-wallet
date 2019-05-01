import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaminari_wallet/widgets/rounded_icon.dart';
import 'package:kaminari_wallet/widgets/wallet/amount_label.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

enum InvoiceStatus { pending, paid, expired }

class InvoiceTile extends StatelessWidget {
  final String name;
  final String description;
  final int amount;
  final InvoiceStatus status;

  const InvoiceTile(
      {Key key, this.name, this.description, this.amount, this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = status == InvoiceStatus.paid
        ? Colors.green
        : status == InvoiceStatus.expired
            ? Colors.red
            : Theme.of(context).primaryColor;
    var icon = status == InvoiceStatus.paid
        ? FontAwesomeIcons.check
        : status == InvoiceStatus.pending
            ? FontAwesomeIcons.fileInvoice
            : FontAwesomeIcons.times;

    return ListTile(
      title: Text("${name ?? "Unknown"}"),
      subtitle: Text("${description ?? "No Description"}"),
      leading: Stack(
        children: <Widget>[
          RoundedIcon(
            child: Icon(FontAwesomeIcons.fileInvoice, color: Colors.white, size: 20,),
            color: Theme.of(context).primaryColor,
            scale: 45.0,
          ),
          OverlayIcon(
            color: color,
            icon: icon,
          )
        ],
      ),
      trailing: AmountLabel(
        text: amount.toString(),
        direction: TxStatus.pending,
      ),
    );
  }
}

class OverlayIcon extends StatelessWidget {

  final Color color;
  final IconData icon;

  const OverlayIcon({Key key, this.color, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0, left: 5.0),
      child: Container(
        width: 44.0,
        height: 44.0,
        child: Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            radius: 10.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Colors.white,
            child: CircleAvatar(
              radius: 8.0,
              backgroundColor: color,
              foregroundColor: Colors.white,
              child: Icon(
                icon,
                size: 8.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
