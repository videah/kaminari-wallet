import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:grpc/grpc.dart';
import 'package:kaminari_wallet/blocs/confirm_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/pages/setup/mainnet_warning_page.dart';
import 'package:kaminari_wallet/pages/setup/success_page.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';

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
          var errorMessage = error.code == GrpcError.unavailable().code
              ? "Connection to node unavailable."
              : "Oops";
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup"),
      ),
      body: StreamBuilder<Object>(
          stream: BlocProvider.of<ConfirmBloc>(context).info,
          builder: (context, snapshot) {
            GetInfoResponse node = snapshot.data;
            if (snapshot.hasData) {
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
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomNavigationBar: StreamBuilder(
        stream: BlocProvider.of<ConfirmBloc>(context).info,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                      MaterialPageRoute(builder: (context) => MainnetWarningPage()),
                    );
                  },
                )
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
