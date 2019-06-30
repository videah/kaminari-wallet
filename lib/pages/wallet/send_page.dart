import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kaminari_wallet/blocs/send_bloc.dart';
import 'package:kaminari_wallet/generated/lnd/lnrpc/rpc.pbgrpc.dart';
import 'package:kaminari_wallet/pages/wallet/payment_error_page.dart';
import 'package:kaminari_wallet/utils/animations.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';
import 'package:kaminari_wallet/widgets/rounded_identicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaminari_wallet/widgets/seperated_list_view.dart';

class SendPage extends StatefulWidget {
  @override
  SendPageState createState() {
    return new SendPageState();
  }
}

class SendPageState extends State<SendPage> with TickerProviderStateMixin {
  AnimationController _buttonController;

  @override
  void initState() {
    super.initState();
    _buttonController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    Future.delayed(Duration(milliseconds: 10)).then(
      (_) {
        BlocProvider.of<SendBloc>(context).result.listen(
              (result) => _buttonController.forward(),
            );
      },
    );
  }

  void onComplete(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data.paymentError == "" ||
          snapshot.data.paymentError == null) {
        Navigator.of(context).pushReplacementNamed("/payment-success");
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentErrorPage(
                  error: snapshot.data.paymentError,
                ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SendBloc>(context);
    return Stack(
      children: <Widget>[
        Hero(
          tag: "test-trans",
          child: Scaffold(
            appBar: AppBar(
              title: Text("Send Payment"),
            ),
            body: StreamBuilder<PayReq>(
              stream: bloc.request,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: DefaultTextStyle.of(context).style.color,
                            fontSize: 18,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 180,
                                child: StreamBuilder<GetInfoResponse>(
                                  stream: bloc.node,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: RoundedIdenticon(
                                              "${snapshot.data.identityPubkey}",
                                              scale: 80,
                                            ),
                                          ),
                                          Text("${snapshot.data.alias}")
                                        ],
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.longArrowAltRight,
                                size: 32,
                              ),
                              Container(
                                width: 180,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: RoundedIdenticon(
                                        "${snapshot.data.destination}",
                                        scale: 80,
                                      ),
                                    ),
                                    StreamBuilder<NodeInfo>(
                                      stream: bloc.destination,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                            "Unknown Node",
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          );
                                        }
                                        if (snapshot.hasData) {
                                          return Text(
                                              "${snapshot.data.node.alias}");
                                        } else {
                                          return Text("");
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 0.0,
                      ),
                      Expanded(
                        child: SeperatedListView(
                          divider: Divider(
                            height: 0.0,
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text("Amount"),
                              subtitle: Text("${snapshot.data.numSatoshis} sat"),
                            ),
                            snapshot.data.description != ""
                                ? ListTile(
                                    title: Text("Description"),
                                    subtitle:
                                        Text("${snapshot.data.description}"),
                                  )
                                : null,
                            ListTile(
                              title: Text("Invoice Date"),
                              subtitle: Text(
                                DateFormat.yMEd()
                                    .format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        snapshot.data.timestamp.toInt() * 1000,
                                      ),
                                    )
                                    .toString(),
                              ),
                            ),
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
            bottomNavigationBar: BottomButtonBar(
              children: <Widget>[
                StreamBuilder<PayReq>(
                  stream: bloc.request,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<Object>(
                        stream: bloc.attempting,
                        builder: (context, attempt) {
                          if (attempt.hasData && attempt.data) {
                            return FillIconButton(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
//                        onTap: () {},
                            );
                          } else {
                            return FillIconButton(
                              child:
                                  Text("Send ${snapshot.data.numSatoshis} sat"),
                              icon: Icon(FontAwesomeIcons.bolt),
                              onTap: () {
                                bloc.startAttempt.add(true);
                              },
                            );
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<SendResponse>(
          stream: BlocProvider.of<SendBloc>(context).result,
          builder: (context, snapshot) {
            Color color = Colors.red;
            if (snapshot.hasData) {
              color = snapshot.data.paymentError == "" ||
                      snapshot.data.paymentError == null
                  ? Colors.green
                  : Colors.red;
            }
            return SuccessAnimation(
              buttonController: _buttonController.view,
              color: color,
              onComplete: () => onComplete(snapshot),
            );
          },
        ),
      ],
    );
  }
}
