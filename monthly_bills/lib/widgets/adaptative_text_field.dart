import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdaptativeTextField extends StatelessWidget {
  const AdaptativeTextField({Key? key, required this.controller, this.keyboardType = TextInputType.text, required this.onSubmit , required this.label}) : super(key: key);

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoTextField(
      controller: controller,
      keyboardType: TextInputType.text,
      placeholder: label,
      onSubmitted: onSubmit(),
    )
    : TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      onSubmitted: onSubmit(),
    );
  }
}