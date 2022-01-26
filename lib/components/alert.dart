
import 'package:flutter/material.dart';

class SimpleAlert{

  static void showMessage(BuildContext context, String message){
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            // コンテンツ領域
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: Text(message),
            ),
          ],
        );
      },
    );
  }
}