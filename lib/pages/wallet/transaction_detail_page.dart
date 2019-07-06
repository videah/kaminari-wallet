import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
import 'package:kaminari_wallet/widgets/rounded_identicon.dart';
import 'package:kaminari_wallet/widgets/seperated_list_view.dart';
import 'package:kaminari_wallet/widgets/wallet/amount_label.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';

class TransactionDetailPage extends StatelessWidget {
  final HistoryItem tx;

  const TransactionDetailPage({Key key, this.tx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var time = DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000);
    var prettyTimestamp = DateFormat.yMMMd().format(time);
    var bloc = BlocProvider.of<MainWalletBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Details"),
      ),
      body: SeperatedListView(
        divider: Divider(
          height: 0.0,
        ),
        children: <Widget>[
          ListTile(
            title: Text("Amount"),
            trailing: AmountLabel(
              text: tx.amount.toString(),
              direction: tx.direction,
            ),
          ),
          ListTile(
            title: Text("Description"),
            subtitle: Text("${tx.memo}"),
          ),
          ListTile(
            title: Text("Date/Time"),
            subtitle: Text("$prettyTimestamp"),
          ),
          if (tx.confirmations != null) ...[
            ListTile(
              title: Text("Confirmations"),
              subtitle: Text("${tx.confirmations}"),
            )
          ],
          if (tx.route != null) ...[
            GroovinExpansionTile(
              boxDecoration: null,
              title: Text("Route"),
              children: <Widget>[
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tx.route.length + 1,
                    itemBuilder: (context, i) {
                      var node;
                      if (i == 0) {
                        node = bloc.getNodeInfo().identityPubkey;
                      } else {
                        node = tx.route[i - 1];
                      }
                      return ListTile(
                        title: FutureBuilder(
                          future: bloc.getNameFromPubKey(node),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Text("Unknown Node");
                            return Text("${snapshot.data}");
                          },
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${node.substring(0, (node.length ~/ 2))}",
                              style: TextStyle(fontFamily: "RobotoMono"),
                            ),
                            Text(
                              "${node.substring((node.length ~/ 2))}",
                              style: TextStyle(fontFamily: "RobotoMono"),
                            ),
                          ],
                        ),
                        leading: RoundedIdenticon(node),
                      );
                    },
                    separatorBuilder: (context, i) {
                      return Divider();
                    },
                  ),
                ),
              ],
            )
          ],
          if (tx.receipt != null) ...[
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Center(child: Text("Preimage")),
                  subtitle: Column(
                    children: <Widget>[
                      Text(
                        "${tx.receipt.substring(0, (tx.receipt.length ~/ 2))}",
                        style: TextStyle(
                          fontFamily: "RobotoMono",
                        ),
                      ),
                      Text(
                        "${tx.receipt.substring((tx.receipt.length ~/ 2))}",
                        style: TextStyle(
                          fontFamily: "RobotoMono",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
