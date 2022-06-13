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
            child: Text('Ok'),
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

  static Future<bool> confirm(BuildContext context, {String title = "Xác nhận", String msg: "Bạn có muốn tiếp tục"}) async {
    bool confirm = true;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget> [
          FlatButton(
            child: Text('Hủy'),
            onPressed: () {
                confirm = false;
                Navigator.of(context).pop(MessageDialog);
            }
          ),
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              confirm = true;
              Navigator.of(context).pop(MessageDialog);
            }
          )
        ]
      ),

    );
    return confirm;
  }
}