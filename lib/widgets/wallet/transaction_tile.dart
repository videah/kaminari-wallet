import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          direction == TxDirection.receiving ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(FontAwesomeIcons.plus, color: Colors.green, size: 12.0,),
          ) : direction == TxDirection.sending ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(FontAwesomeIcons.minus, color: Colors.red, size: 12.0,),
          ) : Container(),
          RichText(
            text: TextSpan(
              text: "1337",
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: " sat", style: TextStyle(fontSize: 13.0)),
              ]
            )
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: image ?? null,
      ),
      onTap: () {},
    );
  }
}
