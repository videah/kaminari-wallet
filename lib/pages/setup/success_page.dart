import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';
import 'package:flutter_svg/svg.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Setup"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              padding: EdgeInsets.all(16.0),
              child: SvgPicture.asset("assets/svg/tada.svg"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Hurray! Everything's good to go!"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: <Widget>[
          FillIconButton(
            child: Text("Complete Setup"),
            onTap: () {
              BlocProvider.of<MainWalletBloc>(context).setup();
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/",
                (_) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
