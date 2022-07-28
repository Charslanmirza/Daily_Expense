import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  late final List<Transaction> transactions;
  final Function deletetrans;
  TransactionList(this.transactions, this.deletetrans);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Flexible(
          child: transactions.isEmpty
              ? LayoutBuilder(builder: (ctx, constraint) {
                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Items Added Yet!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Nothing to show',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      )
                    ],
                  );
                })
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(6),
                      elevation: 6,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: FittedBox(
                                child: Text(
                              '\$${transactions[index].amount}',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                        title: Text(
                          transactions[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Text(DateFormat.yMMMd()
                            .format(transactions[index].date)),
                        trailing: IconButton(
                            color: Colors.red,
                            onPressed: () {
                              deletetrans(transactions[index].id);
                            },
                            icon: Icon(Icons.delete)),
                      ),
                    );
                  },
                  itemCount: transactions.length,
                ),
        ),
      ),
    );
  }
}
