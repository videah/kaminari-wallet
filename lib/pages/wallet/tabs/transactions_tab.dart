import 'package:flutter/material.dart';
import 'package:kaminari_wallet/widgets/wallet/transaction_tile.dart';

class TransactionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
              ],
            ),
          ),
        ),
      ],
    );
  }
}
