import 'package:flutter/material.dart';

class SeperatedListView extends StatelessWidget {

  final List<Widget> children;
  final Widget divider;
  final EdgeInsets padding;

  const SeperatedListView({Key key, this.children, this.divider, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
      separatorBuilder: (context, index) {
        return divider;
      },
    );
  }
}