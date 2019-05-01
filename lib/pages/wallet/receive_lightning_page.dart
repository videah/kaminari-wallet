import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaminari_wallet/widgets/bottom_button_bar.dart';
import 'package:kaminari_wallet/widgets/fill_icon_button.dart';
import 'package:kaminari_wallet/widgets/seperated_list_view.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class ReceiveLightningPage extends StatefulWidget {
  @override
  ReceiveLightningPageState createState() {
    return new ReceiveLightningPageState();
  }
}

class ReceiveLightningPageState extends State<ReceiveLightningPage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _amountFocus = FocusNode();

  final FocusNode _descriptionFocus = FocusNode();

  final amountController = TextEditingController();

  final descriptionController = TextEditingController();

  void _fieldFocusChange(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Invoice"),
      ),
      body: Form(
        key: _formKey,
        child: SeperatedListView(
          divider: Divider(
            height: 0.0,
          ),
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  title: Text("Invoice Amount"),
                  subtitle: Text("How much do you want to request?"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextFormField(
                    controller: amountController,
                    focusNode: _amountFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) return "Amount cannot be empty";
                    },
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onFieldSubmitted: (_) {
                      _formKey.currentState.validate();
                      _fieldFocusChange(
                          context, _amountFocus, _descriptionFocus);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Amount (sat)",
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text("Invoice Description (Optional)"),
                  subtitle: Text("What is the purpose of the invoice?"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: descriptionController,
                    focusNode: _descriptionFocus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text("Expiry Date (Optional)"),
                  subtitle: Text("When do you want the invoice to expire?"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: DateTimePickerFormField(
                    inputType: InputType.both,
                    editable: false,
                    format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Expiry Date",
                    ),
                  ),
                )
              ],
            ),
            CheckboxListTile(
              onChanged: (_) {},
              title: Text("Add Fallback Address"),
              isThreeLine: true,
              subtitle: Text(
                  "Fallback to an on-chain payment in the event that a lightning payment can't be made."),
              value: true,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: <Widget>[
          FillIconButton(
            icon: Icon(FontAwesomeIcons.fileInvoice),
            child: Text("Create Invoice"),
            onTap: () {
              if (_formKey.currentState.validate());
            },
          )
        ],
      ),
    );
  }
}
