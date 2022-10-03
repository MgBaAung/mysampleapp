import 'package:flutter/material.dart';

void showProductDeleteDialog({
  required BuildContext context,
  required VoidCallback callback,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(
          "Are you Sure?",
        ),
        content: new Text(
          "This record will be delete permanently!",
        ),
        actions: <Widget>[
          TextButton(
            child: new Text(
              "No",
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
            child: Text(
              "Delete",
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              callback();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
