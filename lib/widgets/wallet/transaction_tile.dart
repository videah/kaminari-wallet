import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaminari_wallet/widgets/wallet/amount_label.dart';

enum TxDirection { sending, receiving }

List<Color> _aviColors = [
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.brown,
  Colors.blueGrey,
];

List<IconData> _aviIcons = [
  Icons.tag_faces,
  Icons.favorite,
  Icons.alternate_email
];

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
      title: Text("${title  ?? "Unknown"}", style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: subtitle ?? null,
      trailing: AmountLabel(
        text: amount.toString(),
        direction: direction,
      ),
      leading: Stack(
        children: <Widget>[
          CircleAvatar(
//        backgroundImage: image ?? null,
            child: userId != null ? Icon(_aviIcons[userId.hashCode.abs() % _aviIcons.length]) : Text("A"),
            foregroundColor: Colors.white,
            backgroundColor:
                userId != null ? _aviColors[userId.hashCode.abs() % _aviColors.length] : null,
            radius: 20.0,
          ),
          Container(
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
          )
        ],
      ),
      onTap: () {},
    );
  }
}
