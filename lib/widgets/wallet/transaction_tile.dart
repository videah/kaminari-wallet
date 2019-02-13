import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaminari_wallet/widgets/wallet/amount_label.dart';
import 'package:jdenticon_flutter/jdenticon_flutter.dart';

enum TxDirection { sending, receiving }

class TransactionTile extends StatelessWidget {
  final String title;
  final String userId;
  final ImageProvider image;
  final Widget subtitle;
  final TxDirection direction;
  final int amount;

  const TransactionTile(
      {Key key,
      this.title,
      this.image,
      this.subtitle,
      this.direction,
      this.amount,
      this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${title ?? "Unknown"}",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle ?? null,
      trailing: AmountLabel(
        text: amount.toString(),
        direction: direction,
      ),
      leading: Stack(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: userId != null ? Colors.white : Colors.blue,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0.0, 2.0),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: userId != null
                  ? Identicon(userId)
                  : Center(
                      child: Text("?"),
                    ),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _lightningIcon(BuildContext context) {
    return Container(
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
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: Icon(
              FontAwesomeIcons.bolt,
              size: 8.0,
            ),
          ),
        ),
      ),
    );
  }
}
