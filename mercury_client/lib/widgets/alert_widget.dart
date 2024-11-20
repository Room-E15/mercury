import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mercury_client/models/data/alert.dart';

Widget _alertButton(bool isOk, Future<void> Function() onPress) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: isOk ? Colors.green : Colors.red,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: IconButton(
      icon: Icon(isOk ? Icons.check : Icons.close, color: Colors.black),
      iconSize: 24,
      onPressed: onPress,
    ),
  );
}

Widget alertWidgetBuilder(
    {required Queue<Alert> alerts,
    required Future<void> Function() onSafe,
    required Future<void> Function() onUnsafe}) {
  if (alerts.isNotEmpty) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Alert icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF4F378B), // Purple background color
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 30,
            ),
          ),
          SizedBox(width: 16), // Space between icon and text

          // Alert text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alerts.first.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  alerts.first.description,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Alert buttons
          SizedBox(width: 16), // Space between text and buttons
          _alertButton(false, onUnsafe),
          SizedBox(width: 8), // Space between buttons
          _alertButton(true, onSafe),
        ],
      ),
    );
  } else {
    return SizedBox.shrink();
  }
}
