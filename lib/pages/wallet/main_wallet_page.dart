import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/pages/contacts/contact_book_page.dart';
import 'package:kaminari_wallet/pages/settings/settings_page.dart';
import 'package:kaminari_wallet/pages/wallet/tabs/transactions_tab.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';
import 'package:kaminari_wallet/widgets/wallet/send_modal.dart';

class MainWalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MainWalletBloc>(context);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverAppBar(
                  expandedHeight: 0.0,
                  title: StreamBuilder<Object>(
                    stream: bloc.balance,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data}", style: TextStyle(fontSize: 24.0),);
                      } else {
                        return CircularProgressIndicator();
                      }
                    }
                  ),
                  centerTitle: true,
                  floating: false,
                  pinned: true,
                  forceElevated: true,
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(text: "Transactions"),
                      Tab(text: "Invoices"),
                    ],
                  ),
                  leading: IconButton(
                    icon: Icon(FontAwesomeIcons.addressBook),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ContactBookPage())
                      );
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SettingsPage())
                        );
                      },
                    )
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              TransactionsTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(height: 0.0,),
          BottomButtonBar(
            children: <Widget>[
              FillIconButton(
                icon: Icon(Icons.call_received),
                child: Text("Receive"),
                onTap: () {},
              ),
              FillIconButton(
                icon: Icon(Icons.call_made),
                child: Text("Send"),
                onTap: () {
                  showModalBottomSheet(context: (context), builder: (context) {
                    return SendModal();
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}