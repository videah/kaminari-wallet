import 'package:flutter/material.dart';
import 'package:kaminari_wallet/utils/lndconnect.dart';

class ConfirmPage extends StatelessWidget {

  final LNDConnectInfo lnd;

  const ConfirmPage({Key key, this.lnd}) : super(key: key);

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
          Expanded(
            child: ListView(
              children: <Widget>[],
            ),
          )
        ],
      ),
    );
  }
}