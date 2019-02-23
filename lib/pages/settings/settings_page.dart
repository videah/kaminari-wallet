import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/initial_routing_bloc.dart';
import 'package:kaminari_wallet/blocs/node_info_bloc.dart';
import 'package:kaminari_wallet/pages/initial_routing_page.dart';
import 'package:kaminari_wallet/pages/settings/node_info_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Clear node data"),
            subtitle: Text("You'll need to reconnect to use this node again"),
            leading: Icon(Icons.clear_all),
            onTap: () {
              var storage = FlutterSecureStorage();
              storage.deleteAll();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        bloc: InitialRoutingBloc(),
                        child: InitialRoutingPage(),
                      ),
                ),
                (_) => false,
              );
            },
          ),
          ListTile(
            title: Text("Node Info"),
            subtitle: Text("View details about your node"),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        bloc: NodeInfoBloc(),
                        child: NodeInfoPage(),
                      ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
