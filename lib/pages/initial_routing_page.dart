import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/initial_routing_bloc.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/pages/setup/welcome_page.dart';
import 'package:kaminari_wallet/pages/wallet/main_wallet_page.dart';

class InitialRoutingPage extends StatefulWidget {
  @override
  InitialRoutingPageState createState() {
    return new InitialRoutingPageState();
  }
}

class InitialRoutingPageState extends State<InitialRoutingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10)).then(
      (_) {
        BlocProvider.of<InitialRoutingBloc>(context).route.listen(
          (route) {
            Navigator.of(context).pushReplacement(
              InitialPageRoute(
                builder: (context) => route == InitialRoute.home
                    ? BlocProvider(
                        bloc: MainWalletBloc(),
                        child: MainWalletPage(),
                      )
                    : WelcomePage(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
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
