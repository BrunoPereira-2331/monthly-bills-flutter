import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  const AdaptativeDatePicker({Key? key, required this.selectedDate, required this.onDateChange}) : super(key: key);

  final DateTime selectedDate;
  final Function(DateTime) onDateChange;

  _showDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
    .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      onDateChange(pickedDate);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Platform.isIOS 
      ? Container(
        height: 180,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          minimumDate: DateTime(2020),
          maximumDate: DateTime.now(),
          onDateTimeChanged: onDateChange,
        ),
      )
      : Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                            'Selected Date: ${DateFormat('dd/MM/y').format(selectedDate)}')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () => _showDatePicker(context),
                        child: Text(
                          'Select a Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              );
  }
}