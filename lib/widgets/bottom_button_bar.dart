import 'package:flutter/material.dart';

class BottomButtonBar extends StatelessWidget {
  final List<Widget> children;

  const BottomButtonBar({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
