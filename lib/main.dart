import 'dart:io';
import 'package:daily_expenses_management/widgets/tranaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/new_transaction.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Schyler'),
        debugShowCheckedModeBanner: false,
        title: "Personal Expenses",
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _usertransaction = [
    // Transaction(69.99, DateTime.now(), 't1', 'New Shoes'),
    // Transaction(79.99, DateTime.now(), 't2', 'New Bag'),
    // Transaction(89.99, DateTime.now(), 't3', 'New Clothes'),
  ];
  bool showChart = false;
  List<Transaction> get _recentTransactions {
    return _usertransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addnewtransaction(String title, double amount, DateTime chosendate) {
    final newtx = Transaction(
      title,
      amount,
      chosendate,
      DateTime.now().toString(),
    );
    setState(() {
      _usertransaction.add(newtx);
    });
  }

  void _startAddNewTransaction(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return GestureDetector(
              onTap: () {}, child: NewTransaction(_addnewtransaction));
        });
  }

  void _deletetx(String id) {
    showDialog(
        context: context,
        builder: (_) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text('Are you sure'),
                actions: [
                  FlatButton(
                      color: Colors.purple,
                      onPressed: () {
                        setState(() {
                          _usertransaction
                              .removeWhere((element) => element.id == id);
                          // Navigator.of(context).pop();
                        });
                      },
                      child: Text('Yes')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No'))
                ],
              )
            : AlertDialog(
                title: Text('Are you sure'),
                // content: Text('This is my content'),
                actions: [
                  FlatButton(
                      color: Colors.purple,
                      onPressed: () {
                        setState(() {
                          _usertransaction
                              .removeWhere((element) => element.id == id);
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Yes')),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No'))
                ],
              ));

    //
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Daily Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _startAddNewTransaction(context);
                  },
                  icon: Icon(Icons.add),
                )
              ],
            ),
          )
        : AppBar(
            backgroundColor: Colors.purple,
            title: Text('Daily Expenses'),
            actions: [
              IconButton(
                onPressed: () {
                  _startAddNewTransaction(context);
                },
                icon: Icon(Icons.add),
              )
            ],
          );
    final pageBody = SingleChildScrollView(
      child: Column(
        children: [
          if (isLandScape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Show Chart"),
                Switch.adaptive(
                    activeColor: Colors.purple,
                    value: showChart,
                    onChanged: (val) {
                      setState(() {
                        showChart = val;
                      });
                    })
              ],
            ),
          if (!isLandScape)
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
          if (!isLandScape)
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: TransactionList(_usertransaction, _deletetx)),
          if (isLandScape)
            showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: TransactionList(_usertransaction, _deletetx)),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : SafeArea(
            child: Scaffold(
              appBar: appBar,
              body: pageBody,
              floatingActionButton: Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                      onPressed: () {
                        _startAddNewTransaction(context);
                      },
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.add),
                    ),
            ),
          );
  }
}
