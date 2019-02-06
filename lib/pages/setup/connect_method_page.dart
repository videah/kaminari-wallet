import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';

class ConnectMethodPage extends StatelessWidget {

  final List<Widget> methodTiles = [
    ListTile(
      title: Text("Connect via LNConnect QR"),
      subtitle: Text("Connect to your node by scanning a QR code"),
      leading: Icon(FontAwesomeIcons.qrcode),
      onTap: () {

      },
    ),
    ListTile(
      title: Text("Connect via LNConnect URL"),
      subtitle: Text("Connect to your node using your clipboard"),
      leading: Icon(FontAwesomeIcons.clipboard),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "We first need to connect and authenticate with your node.",
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, i) => methodTiles[i],
              separatorBuilder: (context, i) => Divider(),
              itemCount: methodTiles.length,
            ),
          ),
        ],
      ),
    );
  }
}
