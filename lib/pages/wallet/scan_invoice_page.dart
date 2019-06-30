import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/send_bloc.dart';
import 'package:kaminari_wallet/pages/wallet/send_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanInvoicePage extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController _controller;
  bool _alreadyRecognized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Invoice"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.rotate_left),
            onPressed: () {
              _controller.flipCamera();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                QRView(
                  onQRViewCreated: (controller) {
                    final channel = controller.channel;
                    controller.init(qrKey);
                    _controller = controller;
                    channel.setMethodCallHandler((MethodCall call) async {
                      switch (call.method) {
                        case "onRecognizeQR":
                          dynamic arguments = call.arguments;
                          Uri uri = Uri.parse(arguments.toString());
                          String invoice = arguments
                              .toString()
                              .substring(uri.scheme.length + 1);
                          if (!_alreadyRecognized) {
                            _alreadyRecognized = true;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  bloc: SendBloc("$invoice"),
                                  child: SendPage(),
                                ),
                              ),
                            );
                          }
                      }
                    });
                  },
                ),
                ClipPath(
                  clipper: CustomRect(),
                  child: Container(
                    color: Colors.deepPurple,
                    child: Center(
                      child: Hero(
                        tag: "test-trans",
                        child: Container(
                          color: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: Colors.white,
                              width: 315,
                              height: 315,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRect extends CustomClipper<Path> {
  Path getClip(Size size) {
    int radius = 150;
    return Path()
      ..addRRect(
        RRect.fromLTRBR(
          (size.width / 2) - radius,
          (size.height / 2) - radius,
          (size.width / 2) + radius,
          (size.height / 2) + radius,
          Radius.circular(16),
        ),
      )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    return true;
  }
}
