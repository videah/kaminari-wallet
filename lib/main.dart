import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/initial_routing_bloc.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/pages/initial_routing_page.dart';
import 'package:kaminari_wallet/pages/setup/welcome_page.dart';
import 'package:kaminari_wallet/pages/wallet/main_wallet_page.dart';

void main() => runApp(KaminariApp());

class KaminariApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaminari Wallet",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        "/": (context) => BlocProvider<MainWalletBloc>(
              bloc: MainWalletBloc(),
              child: MainWalletPage(),
            ),
        "/initial-router": (context) => BlocProvider<InitialRoutingBloc>(
              bloc: InitialRoutingBloc(),
              child: InitialRoutingPage(),
            ),
        "/setup": (context) => WelcomePage(),
      },
      initialRoute: "/initial-router",
    );
  }
}
