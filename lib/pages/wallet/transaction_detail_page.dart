import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaminari_wallet/blocs/main_wallet_bloc.dart';
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

    List<Step> steps = [
      Step(
        title: Text("You"),
        content: Container(),
      )
    ];
    if (tx.route != null) {
      tx.route.forEach(
        (route) {
          steps.add(
            Step(
              title: Column(
                children: <Widget>[
                  Text("${route.substring(0, (route.length ~/ 2))}"),
                  Text("${route.substring((route.length ~/ 2))}"),
                ],
              ),
              content: Container(),
            ),
          );
        },
      );
      steps[steps.length - 1] = Step(
        title: Text("Destination"),
        content: Container(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Details"),
      ),
      body: SeperatedListView(
        divider: Divider(),
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
          tx.route != null
              ? GroovinExpansionTile(
                  boxDecoration: null,
                  title: Text("Route"),
                  children: <Widget>[
                    Divider(),
                    Stepper(
                      currentStep: steps.length - 1,
                      steps: steps,
                      controlsBuilder: (BuildContext context,
                          {VoidCallback onStepContinue,
                          VoidCallback onStepCancel}) {
                        return Container();
                      },
                    )
                  ],
                )
              : null,
          tx.receipt != null
              ? InkWell(
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
              : null,
        ],
      ),
    );
  }
}
