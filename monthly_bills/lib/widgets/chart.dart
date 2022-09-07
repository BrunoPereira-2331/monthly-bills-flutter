import 'package:flutter/material.dart';
import 'package:monthly_bills/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:monthly_bills/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, required this.recentTransaction}) : super(key: key);

  final List<Transaction> recentTransaction;

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      DateFormat.E().format(weekDay)[0];

      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        var recentTransactionDay = recentTransaction[i].date.day;
        var recentTransactionMonth = recentTransaction[i].date.month;
        var recentTransactionYear = recentTransaction[i].date.year;
        bool sameDay = recentTransactionDay == weekDay.day;
        bool sameMonth = recentTransactionMonth == weekDay.month;
        bool sameYear = recentTransactionYear == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      // print(DateFormat.E().format(weekDay)[0]);
      // print(totalSum);

      return {'day': DateFormat.E().format(weekDay)[0], 'value': totalSum};
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0, (sum, transaction) {
      return sum + double.parse(transaction['value'].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    // List<Flexible> transactions = groupedTransactions.map((transaction) {
    //           double transactionValue =
    //               double.parse(transaction['value'].toString());

    // return Flexible(
    //   fit: FlexFit.tight,
    //     child: ChartBar(
    //         label: transaction['day'].toString(),
    //         value: transactionValue,
    //         percentage: _weekTotalValue == 0 ? 0 : transactionValue / _weekTotalValue));
    //         }).toList();
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
            itemCount: groupedTransactions.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(
              width: _mediaQuery.size.width * 0.05,
            ),
            itemBuilder: (BuildContext context, int index) {
              var currentTransaction = groupedTransactions[index];
              double transactionValue =
                  double.parse(currentTransaction['value'].toString());
              return ChartBar(
                  label: currentTransaction['day'].toString(),
                  value: transactionValue,
                  percentage: _weekTotalValue == 0
                      ? 0
                      : transactionValue / _weekTotalValue);
            })

        //     Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        // children: groupedTransactions2.map((transaction) {
        //   double transactionValue =
        //       double.parse(transaction['value'].toString());

        //   return Flexible(
        //     fit: FlexFit.tight,
        //       child: ChartBar(
        //           label: transaction['day'].toString(),
        //           value: transactionValue,
        //           percentage: _weekTotalValue == 0 ? 0 : transactionValue / _weekTotalValue));
        // }).toList())
        ,
      ),
    );
  }
}
