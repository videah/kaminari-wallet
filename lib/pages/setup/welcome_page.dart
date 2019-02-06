import 'package:flutter/material.dart';
import 'package:kaminari_wallet/pages/setup/connect_method_page.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "雷",
          style: TextStyle(fontSize: 128.0),
        ),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: <Widget>[
          FillIconButton(
            child: Text("Get Started"),
            icon: Icon(FontAwesomeIcons.bolt),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ConnectMethodPage())
              );
            },
          )
        ],
      )
    );
  }
}
