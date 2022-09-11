import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard(
      {Key? key,
      required this.idTransaction,
      required this.titleTransaction,
      required this.valueTransaction,
      required this.dateTransaction,
      required this.callback})
      : super(key: key);

  final String idTransaction;
  final String titleTransaction;
  final double valueTransaction;
  final DateTime dateTransaction;
  final Function callback;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(child: Text('R\$${widget.valueTransaction}')),
          ),
        ),
        title: Text(
          widget.titleTransaction,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat('d MMM y').format(widget.dateTransaction)),
        trailing: MediaQuery.of(context).size.width > 400
            ? TextButton.icon(
                onPressed: () => widget.callback(),
                icon: const Icon(Icons.delete),
                label: const Text("Excluir"),
                style:
                    TextButton.styleFrom(primary: Theme.of(context).errorColor),
              )
            : IconButton(
                onPressed: () => widget.callback(widget.idTransaction),
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
