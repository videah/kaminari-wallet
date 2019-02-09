import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

class AmountLabel extends StatelessWidget {
  final String text;
  final TxDirection direction;

  const AmountLabel({Key key, this.text, this.direction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = direction == TxDirection.receiving ? Colors.green : Colors.red;
    var icon = direction == TxDirection.receiving
        ? FontAwesomeIcons.plus
        : FontAwesomeIcons.minus;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            color: color,
            size: 12.0,
          ),
        ),
        RichText(
          text: TextSpan(
            text: text.replaceAll("-", ""),
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 20.0, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: " sat", style: TextStyle(fontSize: 13.0)),
            ],
          ),
        ),
      ],
    );
  }
}
