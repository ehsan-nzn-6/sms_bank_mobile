import 'package:flutter/material.dart';

void showMySnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    message,
    textAlign: TextAlign.center,
    textDirection: TextDirection.rtl,
    style: TextStyle(
      fontSize: 20,
      color: Colors.red,
    ),
  )));
}
