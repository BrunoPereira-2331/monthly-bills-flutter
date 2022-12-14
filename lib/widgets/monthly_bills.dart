import 'dart:math';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monthly_bills/models/transaction.dart';
import 'package:monthly_bills/widgets/chart.dart';
import 'package:monthly_bills/widgets/transaction_form.dart';
import 'package:monthly_bills/widgets/transaction_list.dart';

class MonthlyBills extends StatefulWidget {
  const MonthlyBills({Key? key}) : super(key: key);

  @override
  State<MonthlyBills> createState() => _MonthlyBillsState();
}

class _MonthlyBillsState extends State<MonthlyBills>
    with WidgetsBindingObserver {
  final List<Transaction> _transactions = [
    Transaction(
        id: '1',
        title: 'Snickers',
        value: 310.76,
        date: DateTime.now().subtract(const Duration(days: 3))),
    Transaction(
        id: '2',
        title: 'Eletricity',
        value: 41.30,
        date: DateTime.now().subtract(const Duration(days: 3))),
    Transaction(
        id: '3',
        title: 'Water',
        value: 111.30,
        date: DateTime.now().subtract(const Duration(days: 4))),
    Transaction(
        id: '4',
        title: 'Supermarket',
        value: 211.30,
        date: DateTime.now().subtract(const Duration(days: 4))),
  ];

  bool _showChart = false;

  List<Transaction> get _getRecentTransactions {
    return _transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
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

    final actions = [
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
            middle: const Text("Monthly Bills"),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: actions),
          )
        : AppBar(
            title: Text(
              "Monthly Bills",
              style: TextStyle(fontSize: 15 * mediaQuery.textScaleFactor),
            ),
            actions: actions,
          )) as PreferredSizeWidget;

    final preferredSizeHeight =
        Platform.isIOS ? 0 : appBar.preferredSize.height;
    final avaliableHeight =
        mediaQuery.size.height - preferredSizeHeight - mediaQuery.padding.top;

    final bodyPage = SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart || !isLandscape)
              SizedBox(
                height: avaliableHeight * (isLandscape ? 0.8 : 0.35),
                child: Chart(recentTransaction: _getRecentTransactions),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                  height: avaliableHeight * (isLandscape ? 1 : 0.65),
                  child: TransactionList(
                      transactions: _transactions, onRemove: _deleteTransaction))
          ],
        ));

    return Platform.isIOS
        ? CupertinoPageScaffold(navigationBar: appBar, child: bodyPage)
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
          );
  }
}
