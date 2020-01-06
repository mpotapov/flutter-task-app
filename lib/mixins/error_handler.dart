import 'package:flutter/material.dart';

abstract class ErrorHandler {
  void showError(BuildContext context, dynamic err) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Error'),
        content: Text(err),
        actions: <Widget>[
          FlatButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
