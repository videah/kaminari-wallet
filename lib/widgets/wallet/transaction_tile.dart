import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaminari_wallet/widgets/wallet/amount_label.dart';

enum TxDirection {sending, receiving}

class TransactionTile extends StatelessWidget {
  final Widget title;
  final ImageProvider image;
  final Widget subtitle;
  final TxDirection direction;

  const TransactionTile({Key key, this.title, this.image, this.subtitle, this.direction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title ?? Text("Unknown Payment"),
      subtitle: subtitle ?? null,
      trailing: AmountLabel(
        text: "1337",
        direction: direction,
      ),
      leading: CircleAvatar(
        backgroundImage: image ?? null,
      ),
      onTap: () {},
    );
  }
}
