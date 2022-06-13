import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class FlashMessage {
  static   void showMessageTop(BuildContext context, String msg) {
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.top,
            behavior: FlashBehavior.fixed,
            child: FlashBar(
              content: Text(msg),
            ),
          );
        });
  }
}