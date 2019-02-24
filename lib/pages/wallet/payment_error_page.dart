import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';

class PaymentErrorPage extends StatelessWidget {

  final String error;

  const PaymentErrorPage({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.times, color: Colors.white, size: 125,),
              ),
              Text("${error[0].toUpperCase()}${error.substring(1)}", style: TextStyle(color: Colors.white, fontSize: 18),)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.red,
        child: BottomButtonBar(
          children: <Widget>[
            FillIconButton(
              backgroundColor: Colors.white,
              textColor: Colors.red,
              child: Text("Close"),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}