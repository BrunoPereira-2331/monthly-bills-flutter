import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'adaptative_button.dart';
import 'adaptative_text_field.dart';
import 'adaptative_button datepicker.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm({Key? key, required this.onSubmit}) : super(key: key);

  final void Function(String, double, DateTime)? onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0;

    if (title.isEmpty || value < 0) {
      return false;
    }

    widget.onSubmit!(title, value, _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              bottom: 10,
              left: 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              AdaptativeTextField(
                label: 'Title',
                controller: _titleController,
                onSubmit: () {},
              ),
              AdaptativeTextField(
                  label: 'Value (R\$)',
                  controller: _valueController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmit: _submitForm,
                  ),
              AdaptativeDatePicker(selectedDate: _selectedDate, onDateChange: (newDate) {
                setState(() {
                    _selectedDate = newDate;
                });
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdaptativeButton(
                    label: 'New Transaction',
                    onPressed: _submitForm,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
