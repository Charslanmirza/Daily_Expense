import 'package:flutter/cupertino.dart';

class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final String id;

  Transaction(this.title, this.amount, this.date, this.id);
}
