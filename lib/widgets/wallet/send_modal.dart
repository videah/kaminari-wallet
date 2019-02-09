import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SendModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text("Send Payment Method"),
          ),
          Divider(height: 0.0,),
          ListTile(
            title: Text("QR Code"),
            subtitle: Text("Scan a payment request"),
            leading: Icon(FontAwesomeIcons.qrcode),
            onTap: () {},
          ),
          ListTile(
            title: Text("Clipboard"),
            subtitle: Text("Paste a payment request"),
            leading: Icon(Icons.content_paste),
            onTap: () {},
          ),
          ListTile(
            title: Text("Contact"),
            subtitle: Text("Send to a contact directly"),
            leading: Icon(Icons.contacts),
            onTap: () {},
          )
        ],
      ),
    );
  }
}