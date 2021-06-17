import 'package:flutter/material.dart';

class AlertDialogText extends StatelessWidget {
  const AlertDialogText({Key key, @required this.textTitle, this.textContent}) : super(key: key);

  final String textTitle;
  final String textContent;

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
        title: Text(textTitle),
        content: Text(textContent),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
  }
}
