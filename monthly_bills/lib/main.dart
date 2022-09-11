import 'dart:math';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monthly_bills/models/transaction.dart';
import 'package:monthly_bills/widgets/chart.dart';
import 'package:monthly_bills/widgets/transaction_form.dart';

import 'widgets/transaction_form.dart';
import 'widgets/transaction_list.dart';

void main() {
  runApp(const MonthlyBillsApp());
}

class MonthlyBillsApp extends StatefulWidget {
  const MonthlyBillsApp({Key? key}) : super(key: key);

  @override
  State<MonthlyBillsApp> createState() => _MonthlyBillsAppState();
}

class _MonthlyBillsAppState extends State<MonthlyBillsApp> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();

    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.purple,
            appBarTheme: AppBarTheme(
                toolbarTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            colorScheme: ThemeData().colorScheme.copyWith(
                  primary: Colors.purple,
                  secondary: Colors.amber,
                )),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  final List<Transaction> _transactions = [
    Transaction(
        id: '1',
        title: 'Snickers',
        value: 310.76,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: '2',
        title: 'Eletricity',
        value: 41.30,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: '3',
        title: 'Water',
        value: 111.30,
        date: DateTime.now().subtract(Duration(days: 4))),
    Transaction(
        id: '4',
        title: 'Supermarket',
        value: 211.30,
        date: DateTime.now().subtract(Duration(days: 4))),
  ];

  bool _showChart = false;

  List<Transaction> get _getRecentTransactions {
    return _transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: DateTime.now());
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return TransactionForm(onSubmit: _addTransaction);
        });
  }

  Widget _getIconButton(IconData icon, Function() callback) {
    return Platform.isIOS
        ? GestureDetector(onTap: callback, child: Icon(icon))
        : IconButton(onPressed: callback, icon: Icon(icon));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final _actions = [
      if (isLandscape)
        _getIconButton(_showChart ? iconList : chartList, () {
          setState(() {
            _showChart = !_showChart;
          });
        }),
      _getIconButton(Platform.isIOS ? CupertinoIcons.add : Icons.add,
          () => _openTransactionFormModal(context)),
    ];

    final dynamic appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text("Monthly Bills"),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: _actions),
          )
        : AppBar(
            title: Text(
              "Monthly Bills",
              style: TextStyle(fontSize: 15 * mediaQuery.textScaleFactor),
            ),
            actions: _actions,
          )) as PreferredSizeWidget;

    final preferredSizeHeight =
        Platform.isIOS ? 0 : appBar.preferredSize.height;
    final avaliableHeight =
        mediaQuery.size.height - preferredSizeHeight - mediaQuery.padding.top;

    final bodyPage = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showChart || !isLandscape)
            Container(
              height: avaliableHeight * (isLandscape ? 0.8 : 0.35),
              child: Chart(recentTransaction: _getRecentTransactions),
            ),
          if (!_showChart || !isLandscape)
            Container(
                height: avaliableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(
                    transactions: _transactions, onRemove: _deleteTransaction))
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(child: bodyPage, navigationBar: appBar)
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isAndroid
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      _openTransactionFormModal(context);
                    },
                  )
                : Container(),
          );
  }
}
