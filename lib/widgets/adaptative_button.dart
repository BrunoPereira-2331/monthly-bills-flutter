import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  const AdaptativeButton({Key? key, required this.label, required this.onPressed}) : super(key: key);

  final String label;
  final Function() onPressed;


  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoButton(child: Text(label), onPressed: onPressed, color: Theme.of(context).primaryColor,)
    : ElevatedButton(
      child: Text(label,
      style: TextStyle(),),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor)
    );
    
  }
}