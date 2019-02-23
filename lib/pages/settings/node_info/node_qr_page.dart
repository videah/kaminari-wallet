import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NodeQrPage extends StatelessWidget {
  final String uri;

  const NodeQrPage({Key key, this.uri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Node QR"),
      ),
      body: Center(
          child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300.0, maxWidth: 300.0),
        child: Card(
          elevation: 8.0,
          color: Colors.white,
          child: QrImage(
            data: "$uri",
            gapless: true,
          ),
        ),
      )),
    );
  }
}
