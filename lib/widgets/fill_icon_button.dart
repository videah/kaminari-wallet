import 'package:flutter/material.dart';

class FillIconButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final Icon icon;
  final Color backgroundColor;
  final Color textColor;
  final bool enabled;

  const FillIconButton({
    Key key,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.child,
    this.textColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon != null
            ? RaisedButton.icon(
                onPressed: enabled ? onTap : null,
                color: backgroundColor ?? Theme.of(context).accentColor,
                label: child,
                textColor: textColor,
                icon: icon,
                colorBrightness: Brightness.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              )
            : RaisedButton(
                onPressed: enabled ? onTap : null,
                child: child,
                textColor: textColor,
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
