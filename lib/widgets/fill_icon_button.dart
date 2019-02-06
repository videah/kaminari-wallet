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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon != null
            ? RaisedButton.icon(
                onPressed: onTap,
                color: backgroundColor ?? Theme.of(context).primaryColor,
                label: child,
                icon: icon,
                colorBrightness: Brightness.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              )
            : RaisedButton(
                onPressed: onTap,
                child: child,
                color: backgroundColor ?? Theme.of(context).primaryColor,
                colorBrightness: Brightness.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
      ),
    );
  }
}
