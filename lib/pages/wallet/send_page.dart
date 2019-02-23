import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/send_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/rounded_identicon.dart';

class SendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Payment"),
      ),
      body: StreamBuilder<PayReq>(
        stream: BlocProvider.of<SendBloc>(context).request,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          RoundedIdenticon(
                            "test",
                            scale: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Alice"),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 42,
                      ),
                      Column(
                        children: <Widget>[
                          RoundedIdenticon(
                            "${snapshot.data.destination}",
                            scale: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StreamBuilder<NodeInfo>(
                              stream: BlocProvider.of<SendBloc>(context)
                                  .destination,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text("${snapshot.data.node.alias}");
                                } else {
                                  return Text("");
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0.0,
                ),
                Expanded(
                  child: ListView(),
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
    );
  }
}
