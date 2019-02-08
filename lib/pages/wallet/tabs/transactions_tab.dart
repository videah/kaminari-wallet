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
                      return Container();
                    },
                    childCount: 4,
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
