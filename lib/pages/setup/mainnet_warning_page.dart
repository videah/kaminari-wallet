import 'package:flutter/material.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';

class MainnetWarningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mainnet Warning"),
      ),
      body: LayoutBuilder(
        builder: (context, viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(),
                  Column(
                    children: <Widget>[
                      Text(
                        "!! WARNING !!\nHERE BE DRAGONS",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.warning,
                        size: 120.0,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "You are trying to connect to a mainnet node\n\n"
                              "Kaminari is a Work in Progress where\n"
                              "freak accidents could happen\n\n"
                              "We won't stop you but just be warned that\n"
                              "YOU CAN LOSE MONEY IF YOU'RE NOT CAREFUL\n\n"
                              "We are not responsible for any loss of funds",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    title: Text("I understand the risks. Let me be reckless!"),
                    subtitle:
                        Text("With great power comes great responsibility"),
                    value: false,
                    onChanged: (_) {},
                  )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomButtonBar(
        children: <Widget>[
          FillIconButton(
            child: Text("Continue"),
          )
        ],
      ),
    );
  }
}
