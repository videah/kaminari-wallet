import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/initial_routing_bloc.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/pages/contacts/contact_book_page.dart';
import 'package:kaminari_wallet/pages/initial_routing_page.dart';
import 'package:kaminari_wallet/pages/setup/welcome_page.dart';
import 'package:kaminari_wallet/pages/wallet/main_wallet_page.dart';
import 'package:kaminari_wallet/pages/wallet/payment_success_page.dart';
import 'package:kaminari_wallet/pages/wallet/receive_lightning_page.dart';

void main() => runApp(KaminariApp());

class KaminariApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainWalletBloc>(
      bloc: MainWalletBloc(),
      child: MaterialApp(
        title: "Kaminari Wallet",
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routes: {
          "/": (context) => MainWalletPage(),
          "/initial-router": (context) => BlocProvider<InitialRoutingBloc>(
                bloc: InitialRoutingBloc(),
                child: InitialRoutingPage(),
              ),
          "/setup": (context) => WelcomePage(),
          "/payment-success": (context) => PaymentSuccessPage(),
          "/create-invoice": (context) => ReceiveLightningPage(),
          "/contacts": (context) => ContactBookPage(),
        },
        initialRoute: "/initial-router",
      ),
    );
  }
}
