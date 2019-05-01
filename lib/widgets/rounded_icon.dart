import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  final Widget child;
  final double scale;
  final Color color;

  const RoundedIcon({Key key, this.child, this.scale, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: scale,
          height: scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0.0, 2.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0 * (scale / 40)),
            child: child,
          ),
        ),
      ],
    );
  }
}
