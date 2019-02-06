import 'package:flutter/material.dart';

class FillIconButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final Icon icon;
  final Color backgroundColor;
  final Color textColor;

  const FillIconButton(
      {Key key,
      this.onTap,
      this.icon,
      this.backgroundColor,
      this.child,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        onPressed: onTap,
        color: backgroundColor,
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: child,
                )
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0.0),
          ),
        ),
      ),
    );
  }
}
