import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:grpc/grpc.dart';
import 'package:jdenticon_flutter/jdenticon_flutter.dart';
import 'package:kaminari_wallet/blocs/confirm_bloc.dart';
import 'package:kaminari_wallet/blocs/mainnet_warning_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/pages/setup/mainnet_warning_page.dart';
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
                      Container(
                        width: 150,
                        height: 150,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0.0, 2.0),
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Identicon(node.identityPubkey),
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
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: bloc.info,
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
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
