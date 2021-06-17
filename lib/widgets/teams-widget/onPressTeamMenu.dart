import 'package:flutter/material.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/widgets/teams-widget/renameATeamDialog.dart';

class OnPressTeamMenu extends StatelessWidget {
  const OnPressTeamMenu(
      {Key key,
        @required this.team,
        @required this.onRenamedTeam,
        @required this.onCloneTeam,
        @required this.onShareTextTeam})
      : super(key: key);
  final Team team;
  final Function(Team team, String name) onRenamedTeam;
  final Function(Team team) onCloneTeam;
  final Function(Team team) onShareTextTeam;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Team Menu:'),
      children: [
        OnPressTeamMenuItem(
          icon: Icons.text_fields,
          color: Colors.grey,
          text: 'rename',
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RenameATeamDialog(
                      team: team, onRenamedTeam: onRenamedTeam);
                });
            Navigator.pop(context, 'rename');
          },
        ),
        OnPressTeamMenuItem(
          icon: Icons.copy,
          color: Colors.grey,
          text: 'clone',
          onPressed: () async {
            onCloneTeam(team);
            Navigator.pop(context, 'clone');
          },
        ),
        OnPressTeamMenuItem(
          icon: Icons.ios_share,
          color: Colors.grey,
          text: 'share text',
          onPressed: () async {
            onShareTextTeam(team);
            Navigator.pop(context, 'share');
          },
        ),
      ],
    );
  }
}

class OnPressTeamMenuItem extends StatelessWidget {
  const OnPressTeamMenuItem(
      {Key key, this.icon, this.color, this.text, this.onPressed})
      : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed; //TODO capire cosa significa VoidCallback

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

