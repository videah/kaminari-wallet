import 'package:flutter/material.dart';
import 'package:jdenticon_flutter/jdenticon_flutter.dart';
import 'package:kaminari_wallet/widgets/rounded_icon.dart';

class RoundedIdenticon extends StatelessWidget {
  final String text;
  final double scale;

  const RoundedIdenticon(this.text, {Key key, this.scale = 40.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _Identicon(
        text: text,
        scale: scale,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SimpleDialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _Identicon(
                            text: text,
                            scale: 200,
                          ),
                        ),
                        Card(
                          elevation: 4.0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "${text.substring(0, 22)}",
                                  style: TextStyle(
                                      fontFamily: "RobotoMono",
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Text(
                                  "${text.substring(22, 44)}",
                                  style: TextStyle(
                                      fontFamily: "RobotoMono",
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                                Text(
                                  "${text.substring(44)}",
                                  style: TextStyle(
                                      fontFamily: "RobotoMono",
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Identicon extends StatelessWidget {
  final String text;
  final double scale;

  const _Identicon({Key key, this.text, this.scale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedIcon(
      scale: scale,
      color: text != null ? Colors.white : Colors.blue,
      child: text != null
          ? Identicon(text)
          : Center(
              child: Text("?"),
            ),
    );
  }
}
