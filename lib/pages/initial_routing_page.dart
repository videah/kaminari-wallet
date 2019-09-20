import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/initial_routing_bloc.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';

class InitialRoutingPage extends StatefulWidget {
  @override
  InitialRoutingPageState createState() {
    return new InitialRoutingPageState();
  }
}

class InitialRoutingPageState extends State<InitialRoutingPage> {

  Future _goToMainWallet() async {
    await Future.delayed(Duration(seconds: 1));
    BlocProvider.of<MainWalletBloc>(context).setup();
    Navigator.of(context).pushNamed("/");
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10)).then(
      (_) {
        BlocProvider.of<InitialRoutingBloc>(context).route.listen(
          (route) {
            if (route == InitialRoute.home) {
              _goToMainWallet();
            } else {
              Navigator.of(context).pushNamed("/setup");
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}

class InitialPageRoute<T> extends MaterialPageRoute<T> {
  InitialPageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeUpwardsPageTransitionsBuilder()
        .buildTransitions(this, context, animation, secondaryAnimation, child);
  }
}
