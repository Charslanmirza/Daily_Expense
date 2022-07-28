import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addtx;
  NewTransaction(this.addtx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titlecontroller = TextEditingController();

  final amountcontroller = TextEditingController();
  DateTime? _selecteddate;

  void onSubmit() {
    final enteredtext = titlecontroller.text;
    final enteredamount = double.parse(amountcontroller.text);
    if (enteredtext.isEmpty ||
        enteredamount < 0 ||
        enteredtext.isEmpty ||
        _selecteddate == null) {
      return;
    }
    widget.addtx(enteredtext, enteredamount, _selecteddate);
    Navigator.of(context).pop();
  }

  void _pickeddate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          _selecteddate = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 10,
              right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                onSubmitted: (value) => onSubmit(),
                controller: titlecontroller,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onSubmitted: (value) => onSubmit(),
                keyboardType: TextInputType.number,
                controller: amountcontroller,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ignore: unnecessary_null_comparison
                    Text(_selecteddate == null
                        ? "No Data Chosen"
                        : 'Picked Date : ${DateFormat.yMd().format(_selecteddate!)}'),
                    FlatButton(
                        onPressed: _pickeddate,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ))
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(),
                      ),
                      color: Colors.purple,
                      onPressed: onSubmit,
                    )
                  : RaisedButton(
                      color: Colors.purple,
                      textColor: Colors.white,
                      onPressed: onSubmit,
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
