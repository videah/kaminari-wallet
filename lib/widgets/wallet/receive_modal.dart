import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReceiveModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text("Receive Payment"),
          ),
          Divider(
            height: 0.0,
          ),
          ListTile(
            title: Text("Receive with Lightning"),
            subtitle: Text("Instant, Cheap, Like a Debit Card Payment"),
            leading: Card(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.bolt, color: Colors.white, size: 18,),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/create-invoice");
            },
          ),
          ListTile(
            title: Text("Receive On-Chain"),
            subtitle: Text("Slow, Expensive, Like a Bank Transfer"),
            leading: Card(
              color: Colors.orange,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.link, color: Colors.white, size: 18,),
              ),
            ),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}
