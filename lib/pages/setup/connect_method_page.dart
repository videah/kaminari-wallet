import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';

class ConnectMethodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> methodTiles = [
      ListTile(
        title: Text("Connect via LNDConnect QR"),
        subtitle: Text("Connect to your node by scanning a QR code"),
        leading: Icon(FontAwesomeIcons.qrcode),
        onTap: () {
          _scanForQR(context);
        },
      ),
      ListTile(
        title: Text("Connect via LNDConnect URL"),
        subtitle: Text("Connect to your node using your clipboard"),
        leading: Icon(FontAwesomeIcons.clipboard),
      ),
    ];

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

  _scanForQR(context) async {
    try {
      String qr = await BarcodeScanner.scan();
      var test = LNDConnect.decode(qr);
      print(test.address);
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("There was an issue with scanning the QR code."),
            actions: <Widget>[
              FlatButton(
                child: Text("CLOSE"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        },
      );
    }
  }
}
