import 'package:flutter/material.dart';
import 'package:jdenticon_flutter/jdenticon_flutter.dart';

class RoundedIdenticon extends StatelessWidget {
  final String text;
  final double scale;

  const RoundedIdenticon(this.text, {Key key, this.scale = 40.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: scale,
          height: scale,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: text != null ? Colors.white : Colors.blue,
            boxShadow: [
              new BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0.0, 2.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0 * (scale / 40)),
            child: text != null
                ? Identicon(text)
                : Center(
              child: Text("?"),
            ),
          ),
        ),
      ],
    );
  }
}
