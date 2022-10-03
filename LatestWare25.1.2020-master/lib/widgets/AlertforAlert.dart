import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert(BuildContext context, String text) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Notice'),
      
        content: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "OK",
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
