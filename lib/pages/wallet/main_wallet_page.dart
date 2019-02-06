import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainWalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.addressBook),
                  onPressed: () {},
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("123456789 sat", style: TextStyle(fontSize: 24.0),),
                  centerTitle: true,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverTabBarDelegate(
                  tabBar: TabBar(
                    labelColor: Theme.of(context).accentColor,
                    tabs: <Widget>[
                      Tab(text: "Transactions"),
                      Tab(text: "Invoices"),
                    ],
                  )
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              Center(
                child: Text("Hello World"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  SliverTabBarDelegate({this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: Column(
        children: <Widget>[
          Divider(height: 0.0),
          tabBar,
          Divider(height: 0.0),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }
}