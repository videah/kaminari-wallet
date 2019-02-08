import 'package:flutter/material.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

class TransactionsTab extends StatelessWidget {

  /// The [Transform] widgets are an ugly hack to make the [RefreshIndicator]
  /// appear in the right place when using [SliverOverlapAbsorber]
  /// and [SliverOverlapInjector] to fix the sliver layout.

  @override
  Widget build(BuildContext context) {
    var overlapAbsorber =
        NestedScrollView.sliverOverlapAbsorberHandleFor(context);
    return Transform.translate(
      offset: Offset(0.0, overlapAbsorber.layoutExtent),
      child: RefreshIndicator(
        onRefresh: () async {},
        child: Transform.translate(
          offset: Offset(0.0, -overlapAbsorber.layoutExtent),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(handle: overlapAbsorber),
              SliverPadding(
                padding: EdgeInsets.all(0.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return TransactionTile(
                        title: Text("Satoshi Nakamoto", style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text("Testing out the lightning network"),
                        direction: TxDirection.receiving,
                        image: NetworkImage(
                          "https://pbs.twimg.com/profile_images/941678006606729217/C4L6sQEf_400x400.jpg",
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
