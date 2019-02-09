import 'package:flutter/material.dart';
import 'package:kaminari_wallet/pages/contacts/new_contact_page.dart';

class ContactBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewContactPage())
              );
            },
          )
        ],
      ),
      body: ListView(),
    );
  }
}