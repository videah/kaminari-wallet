import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/send_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/rounded_identicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                      Container(
                        width: 180,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: RoundedIdenticon(
                                "test",
                                scale: 80,
                              ),
                            ),
                            Text("Bob")
                          ],
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.longArrowAltRight,
                        size: 32,
                      ),
                      Container(
                        width: 180,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: RoundedIdenticon(
                                "${snapshot.data.destination}",
                                scale: 80,
                              ),
                            ),
                            StreamBuilder<NodeInfo>(
                              stream: BlocProvider.of<SendBloc>(context)
                                  .destination,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text("${snapshot.data.node.alias}");
                                } else {
                                  return Text("");
                                }
                              },
                            )
                          ],
                        ),
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
