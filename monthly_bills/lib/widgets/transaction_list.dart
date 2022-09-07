import 'package:flutter/material.dart';
import 'package:monthly_bills/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:monthly_bills/widgets/transaction_card.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(
      {Key? key, required this.transactions, required this.onRemove})
      : super(key: key);

  final List<Transaction> transactions;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Text("Empty Transactions!",
                      style: Theme.of(context).textTheme.headline6),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2irS6SVFvcX4FBxXXWmrhe8MOHJc3slgmEg&usqp=CAU",
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          ): 
        ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionCard(
                key: GlobalObjectKey(transaction),
                idTransaction: transaction.id,
                titleTransaction: transaction.title,
                valueTransaction: transaction.value,
                dateTransaction: transaction.date,
                callback: onRemove
              );
            },
          );
  }
}
