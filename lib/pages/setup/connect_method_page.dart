import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/confirm_bloc.dart';
import 'package:kaminari_wallet/pages/setup/confirm_page.dart';
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
      Builder(
        builder: (context) {
          return ListTile(
            title: Text("Connect via LNDConnect URL"),
            subtitle: Text("Connect to your node using your clipboard"),
            leading: Icon(FontAwesomeIcons.clipboard),
            onTap: () {
              _connectFromClipboard(context);
            },
          );
        },
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

  _connectFromClipboard(context) async {
    try {
      Scaffold.of(context).removeCurrentSnackBar();
      final uri = await Clipboard.getData(Clipboard.kTextPlain);
      final lndOptions = LNDConnect.decode(uri.text);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            bloc: ConfirmBloc(lndOptions),
            child: ConfirmPage(),
          ),
        ),
      );
    } catch (e, s) {
      print(e);
      print(s);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: ListTile(
            title: Text("Clipboard does not contain valid URL"),
            subtitle: Text("Are you sure you copied it right?"),
            leading: Icon(Icons.error),
          )
        ),
      );
    }
  }

  _scanForQR(context) async {
    try {
      var qr = await BarcodeScanner.scan();
      var lnd = LNDConnect.decode(qr);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            bloc: ConfirmBloc(lnd),
            child: ConfirmPage(),
          ),
        ),
      );
    } on PlatformException {
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
