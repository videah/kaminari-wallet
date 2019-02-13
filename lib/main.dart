import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/initial_routing_bloc.dart';
import 'package:kaminari_wallet/pages/initial_routing_page.dart';

void main() => runApp(KaminariApp());

class KaminariApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaminari Wallet",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: BlocProvider(
        bloc: InitialRoutingBloc(),
        child: InitialRoutingPage(),
      ),
    );
  }
}
