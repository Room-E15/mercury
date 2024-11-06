import 'package:flutter/material.dart';

Future<T?> showPopup<T>(BuildContext context, String title, String content,
    {String? buttonText}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      );
    },
  );
}
