import 'package:flutter/material.dart';
import 'package:poke_team/model/team.dart';

class TeamTile extends StatelessWidget {
  const TeamTile({Key key, @required this.team, @required this.onTeamTap}) : super(key: key);
  final Team team;
  final Future<void> Function(Team team) onTeamTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.cyan,
      shadowColor: Colors.black,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.elliptical(20, 40)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListTile(
          dense: true,
          title: Text('${team.name}', style: TextStyle(fontSize: 24),),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: team.teamMembers.map((pokemon) { return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[400],
                    backgroundImage: NetworkImage(
                      pokemon.urlSprite,
                    ),),
              );}).toList(),
            ),
          ),
          tileColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.elliptical(20, 40),
                topRight: Radius.elliptical(100, 40)),
          ),
          onTap:  () async => await onTeamTap(team),
        ),
      ),
    );
  }
}
