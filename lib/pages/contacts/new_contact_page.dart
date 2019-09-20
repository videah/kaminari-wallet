import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';

class NewContactPage extends StatelessWidget {

  var _nameController = TextEditingController();
  var _keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Contact"),
      ),
      body: ListView(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name"
            ),
          ),
          TextFormField(
            controller: _keyController,
            decoration: InputDecoration(
                labelText: "Pubkey"
            ),
          ),
          BottomButtonBar(
            children: <Widget>[
              FillIconButton(
                child: Text("Create Contact"),
                icon: Icon(FontAwesomeIcons.addressBook),
                onTap: () {
                  var box = Hive.box("contacts");
                  var contact = {
                    "name": _nameController.value.text,
                    "pubkey": _keyController.value.text
                  };
                  box.add(contact);
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}