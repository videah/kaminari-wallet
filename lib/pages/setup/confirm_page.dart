import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:grpc/grpc.dart';
import 'package:kaminari_wallet/blocs/confirm_bloc.dart';
import 'package:kaminari_wallet/blocs/mainnet_warning_bloc.dart';
import 'package:kaminari_wallet/generated/lnd/lnrpc/rpc.pbgrpc.dart';
import 'package:kaminari_wallet/pages/setup/mainnet_warning_page.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';
import 'package:kaminari_wallet/widgets/rounded_identicon.dart';

class ConfirmPage extends StatefulWidget {
  @override
  ConfirmPageState createState() {
    return new ConfirmPageState();
  }
}

class ConfirmPageState extends State<ConfirmPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10)).then((_) {
      BlocProvider.of<ConfirmBloc>(context).status.listen(
        (error) {
          print(error);
          var errorMessage = error.code == GrpcError.unavailable().code
              ? "Connection to node unavailable."
              : "Unknown Error Occured";
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("$errorMessage"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("CLOSE"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            },
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ConfirmBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup"),
      ),
      body: StreamBuilder<Object>(
        stream: bloc.info,
        builder: (context, snapshot) {
          GetInfoResponse node = snapshot.data;
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Does this look right?",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: RoundedIdenticon(
                        node.identityPubkey,
                        scale: 150,
                      ),
                    ),
                    ListTile(
                      title: Text("Name"),
                      subtitle: Text("${node.alias}"),
                    ),
                    ListTile(
                      title: Text("Public Key"),
                      subtitle: Text("${node.identityPubkey}"),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: bloc.info,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return BottomAppBar();
          }
          return BottomButtonBar(
            children: <Widget>[
              FillIconButton(
                icon: Icon(Icons.close),
                backgroundColor: Colors.red,
                child: Text("No"),
                onTap: () {},
              ),
              FillIconButton(
                icon: Icon(Icons.check),
                backgroundColor: Colors.green,
                child: Text("Yes"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider(
                          bloc: MainnetWarningBloc(
                            bloc.lndOptions,
                          ),
                          child: MainnetWarningPage(),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
