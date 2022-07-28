import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart(this.recentTransactions);

  List<Map<String, Object?>> get groupTransactionValue {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalSum += recentTransactions[i].amount;
        }
        // totalSum += recentTransactions[i].amount;
      }
      // print(totalSum);
      // print(DateFormat.E().format(weekday));

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSPending {
    return groupTransactionValue.fold(0, (previousValue, element) {
      return previousValue + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupTransactionValue);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: groupTransactionValue.map((data) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                      (data['day'] as String),
                      (data['amount'] as double),
                      maxSPending == 0.0
                          ? 0
                          : (data['amount'] as double) / maxSPending),
                );
              }).toList()),
        ),
      ),
    );
  }
}
