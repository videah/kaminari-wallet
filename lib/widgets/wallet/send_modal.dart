import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/send_bloc.dart';
import 'package:kaminari_wallet/pages/wallet/scan_invoice_page.dart';
import 'package:kaminari_wallet/pages/wallet/send_page.dart';

class SendModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text("Send Payment"),
          ),
          Divider(
            height: 0.0,
          ),
          ListTile(
            title: Text("QR Code"),
            subtitle: Text("Scan a payment request"),
            leading: Icon(FontAwesomeIcons.qrcode),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ScanInvoicePage())
              );
            },
          ),
          ListTile(
            title: Text("Clipboard"),
            subtitle: Text("Paste a payment request"),
            leading: Icon(Icons.content_paste),
            onTap: () {
              Clipboard.getData(Clipboard.kTextPlain).then((data) {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      bloc: SendBloc("${data.text}"),
                      child: SendPage(),
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
