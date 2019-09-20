import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:hive/hive.dart';
import 'package:kaminari_wallet/blocs/initial_routing_bloc.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/blocs/node_info_bloc.dart';
import 'package:kaminari_wallet/pages/initial_routing_page.dart';
import 'package:kaminari_wallet/pages/settings/node_info/node_info_page.dart';
import 'package:kaminari_wallet/widgets/seperated_list_view.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SeperatedListView(
        divider: Divider(height: 0.0,),
        children: <Widget>[
          ListTile(
            title: Text("Node Info"),
            subtitle: Text("View details about your node"),
            trailing: Icon(Icons.info),
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
          ),
          ListTile(
            title: Text("Clear node data"),
            subtitle: Text("You'll need to reconnect to use this node again"),
            trailing: Icon(Icons.clear_all),
            onTap: () {
              var storage = Hive.box("lndconnect");
              storage.deleteFromDisk();
              BlocProvider.of<MainWalletBloc>(context).dispose();
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
        ],
      ),
    );
  }
}
