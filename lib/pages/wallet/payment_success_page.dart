import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentSuccessPage extends StatefulWidget {
  @override
  PaymentSuccessPageState createState() {
    return new PaymentSuccessPageState();
  }
}

class PaymentSuccessPageState extends State<PaymentSuccessPage> {

  String heroTag = "button-to-success";
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() => heroTag = "invalidate-hero");
      Navigator.popUntil(context, ModalRoute.withName("/"));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: heroTag,
        child: Container(
          color: Colors.green,
          child: Center(
            child: Icon(FontAwesomeIcons.check, color: Colors.white, size: 125,),
          ),
        ),
      ),
    );
  }
}