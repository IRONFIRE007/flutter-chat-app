import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

viewAlert(BuildContext context, String title, String subTitle) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(subTitle),
              actions: [
                MaterialButton(
                    child: const Text('ok'),
                    textColor: Colors.blue,
                    elevation: 5,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  } else {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(subTitle),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }
}
