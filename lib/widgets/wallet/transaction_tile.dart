import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaminari_wallet/widgets/rounded_icon.dart';
import 'package:kaminari_wallet/widgets/rounded_identicon.dart';
import 'package:kaminari_wallet/widgets/wallet/amount_label.dart';

enum TxStatus { sending, receiving, pending }

class TransactionTile extends StatelessWidget {
  final String title;
  final String userId;
  final ImageProvider image;
  final Widget subtitle;
  final TxStatus direction;
  final int amount;
  final GestureTapCallback onTap;

  const TransactionTile(
      {Key key,
      this.title,
      this.image,
      this.subtitle,
      this.direction,
      this.amount,
      this.userId,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        firstChild: Text(
          "Unknown",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        secondChild: Text(
          "${title ?? "Unknown"}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        crossFadeState: title == "Unknown"
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
      subtitle: subtitle ?? null,
      trailing: AmountLabel(
        text: amount.toString(),
        direction: direction,
      ),
      leading: userId != null
          ? RoundedIdenticon(userId)
          : RoundedIcon(
              scale: 40,
              color: Colors.orange,
              child: Center(
                child: Icon(
                  FontAwesomeIcons.link,
                  color: Colors.white,
                ),
              ),
            ),
      onTap: onTap,
    );
  }

//  Widget _lightningIcon(BuildContext context) {
//    return Container(
//      width: 44.0,
//      height: 44.0,
//      child: Align(
//        alignment: Alignment.bottomRight,
//        child: CircleAvatar(
//          radius: 10.0,
//          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//          foregroundColor: Colors.white,
//          child: CircleAvatar(
//            radius: 8.0,
//            backgroundColor: Colors.blue,
//            foregroundColor: Colors.white,
//            child: Icon(
//              FontAwesomeIcons.bolt,
//              size: 8.0,
//            ),
//          ),
//        ),
//      ),
//    );
//  }
}
