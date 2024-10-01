import 'package:flutter/material.dart';

class Snackbarwidget {
  void ShowSnackbar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
      children: [
        Icon(
          Icons.error,
          color: Colors.amber,
        ),
        SizedBox(
          width: 20,
        ),
        Text(message),
      ],
    )));
  }
}
