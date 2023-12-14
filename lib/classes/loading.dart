import 'package:flutter/material.dart';

class Loading {
  late AlertDialog alert;

  load(BuildContext context, String message) async {
    alert = AlertDialog(
      content: ListTile(
        leading: const CircularProgressIndicator(),
        title: Text(message),
        // subtitle: Text(translate('options.contact_subtitle')),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  cancel(BuildContext context) async {
    Navigator.pop(context);
  }
}
