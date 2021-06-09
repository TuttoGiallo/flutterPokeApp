import 'package:flutter/material.dart';

class AlertDialogInputString extends StatelessWidget {
  AlertDialogInputString({Key key, @required this.title, this.helpText = ''}) : super(key: key);

  final TextEditingController textController = new TextEditingController();
  final String title;
  final String helpText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a Team:'),
      content: SizedBox(
        width: 250,
        child: TextField(
            controller: textController,
            key: key,
            decoration: const InputDecoration(
                helperText: "Enter the name of the new team"),
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.grey[800],
              fontStyle: FontStyle.italic,
            )),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, {'ok': false}),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context, {'ok': true, 'inputText': textController.text});
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
