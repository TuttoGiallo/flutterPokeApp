import 'package:flutter/material.dart';
import 'package:poke_team/model/team.dart';

class RenameATeamDialog extends StatelessWidget {
  RenameATeamDialog(
      {Key key, @required this.onRenamedTeam, @required this.team})
      : super(key: key);

  final Function(Team team, String teamName) onRenamedTeam;
  final TextEditingController textController = new TextEditingController();
  final Team team;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename a Team:'),
      content: SizedBox(
        width: 250,
        child: TextField(
            controller: textController,
            key: key,
            decoration:
            const InputDecoration(helperText: "Enter the team's name"),
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
            onRenamedTeam(team, textController.text);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}