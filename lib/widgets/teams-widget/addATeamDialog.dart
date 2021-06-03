import 'package:flutter/material.dart';

class AddATeamDialog extends StatelessWidget {
  AddATeamDialog({Key key, @required this.onAddedTeam}) : super(key: key);

  final Function(String teamName) onAddedTeam;
  final TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextField textField;
    return AlertDialog(
      title: const Text('Add a Team:'),
      content: SizedBox(
        width: 250,
        child: textField = TextField(
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onAddedTeam(textController.text);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
