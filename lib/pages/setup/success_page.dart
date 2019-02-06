import 'package:flutter/material.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Setup"),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: <Widget>[
          FillIconButton(
            child: Text("Complete Setup"),
            onTap: () {},
          )
        ],
      ),
    );
  }
}