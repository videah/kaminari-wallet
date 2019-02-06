import 'package:flutter/material.dart';
import 'package:kaminari_wallet/pages/setup/welcome_page.dart';

void main() => runApp(KaminariApp());

class KaminariApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaminari Wallet",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: WelcomePage(),
    );
  }
}