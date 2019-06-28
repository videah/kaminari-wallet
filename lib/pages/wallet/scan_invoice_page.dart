import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';

class ScanInvoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World"),
      ),
      body: QrReaderView(),
    );
  }
}