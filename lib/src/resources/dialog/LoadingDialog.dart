import 'package:flutter/material.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context, String msg) {
    showDialog(context: context, barrierDismissible: false,
      builder: (context) => new Dialog(
        child: Container(
          color: Colors.white,
          height:100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  msg,
                  style: TextStyle(fontSize: 18)
                  )
              )
            ],
          )
        )
      )
    );
  }
  static Widget  ajaxLoadListView() {
    return SizedBox(
        width: 50, height: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 203, 205, 214),
            strokeWidth: 2.0,
          ),
        ),
      );
  }
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}