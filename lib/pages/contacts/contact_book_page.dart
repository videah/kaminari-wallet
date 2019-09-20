import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kaminari_wallet/pages/contacts/new_contact_page.dart';

class ContactBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Hive.box("contacts").clear();
            },
          ),
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
      body: WatchBoxBuilder(
        box: Hive.box("contacts"),
        builder: (context, box) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, i) {
              print(box.getAt(i));
              return ListTile(
                title: Text("${box.getAt(i)["name"]}"),
                subtitle: Text("${box.getAt(i)["pubkey"]}"),
              );
            },
          );
        },
      )
    );
  }
}