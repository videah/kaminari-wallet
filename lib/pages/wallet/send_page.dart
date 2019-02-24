import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/send_bloc.dart';
import 'package:kaminari_wallet/generated/protos/lnrpc.pbgrpc.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';
import 'package:kaminari_wallet/widgets/rounded_identicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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
                  child: DefaultTextStyle(
                    style: TextStyle(
                        color: DefaultTextStyle.of(context).style.color,
                        fontSize: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 180,
                          child: StreamBuilder<GetInfoResponse>(
                            stream: BlocProvider.of<SendBloc>(context).node,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: RoundedIdenticon(
                                        "${snapshot.data.identityPubkey}",
                                        scale: 80,
                                      ),
                                    ),
                                    Text("${snapshot.data.alias}")
                                  ],
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
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
                                  if (snapshot.hasError) {
                                    return Text(
                                      "Unknown Node",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    );
                                  }
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
                ),
                Divider(
                  height: 0.0,
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text("Amount"),
                        subtitle: Text("${snapshot.data.numSatoshis} sat"),
                      ),
                      ListTile(
                        title: Text("Description"),
                        subtitle: Text("${snapshot.data.description}"),
                      ),
                      ListTile(
                        title: Text("Invoice Date"),
                        subtitle: Text(
                          DateFormat.yMEd()
                              .format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data.timestamp.toInt() * 1000,
                                ),
                              )
                              .toString(),
                        ),
                      ),
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
      bottomNavigationBar: BottomButtonBar(
        children: <Widget>[
          StreamBuilder<PayReq>(
            stream: BlocProvider.of<SendBloc>(context).request,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FillIconButton(
                  child: Text("Send ${snapshot.data.numSatoshis} sat"),
                  icon: Icon(FontAwesomeIcons.bolt),
                  onTap: () {},
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
