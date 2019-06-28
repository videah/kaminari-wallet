import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/node_info_bloc.dart';
import 'package:kaminari_wallet/generated/lnd/lnrpc/rpc.pbgrpc.dart';
import 'package:kaminari_wallet/pages/settings/node_info/node_qr_page.dart';
import 'package:kaminari_wallet/widgets/rounded_identicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NodeInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Node Info"),
        actions: <Widget>[
          StreamBuilder<GetInfoResponse>(
            stream: BlocProvider.of<NodeInfoBloc>(context).nodeInfo,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(FontAwesomeIcons.qrcode),
                onPressed: snapshot.hasData
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NodeQrPage(
                                  uri: snapshot.data.identityPubkey,
                                ),
                          ),
                        );
                      }
                    : null,
              );
            },
          )
        ],
      ),
      body: StreamBuilder<GetInfoResponse>(
        stream: BlocProvider.of<NodeInfoBloc>(context).nodeInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RoundedIdenticon(
                          snapshot.data.identityPubkey,
                          scale: 150,
                        ),
                      ),
                      Text(
                        "${snapshot.data.alias}",
                        style: Theme.of(context).textTheme.headline,
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 0.0,
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text("Block Height"),
                        subtitle: Text("${snapshot.data.blockHeight}"),
                      ),
                      ListTile(
                        title: Text("Pub Key"),
                        subtitle: Text("${snapshot.data.identityPubkey}"),
                      ),
                      ListTile(
                        title: Text("Synced"),
                        trailing: Text("${snapshot.data.syncedToChain}"),
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
    );
  }
}
