import 'package:flutter/material.dart';

class MessageDialog {
  static void showMessageDialog(BuildContext context, String title, String msg, [Function? dimiss]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget> [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              if (dimiss == null) {
                Navigator.of(context).pop(MessageDialog);
              } else {
                dimiss();
              }
            }
          )
        ]
      ),

    );
  }
}