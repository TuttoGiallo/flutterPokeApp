import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokemon-widget/singlePokeStat.dart';

class TeamStats extends StatelessWidget {
  const TeamStats({Key key, @required this.team}) : super(key: key);
  final Team team;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetsStats = [];
    if (team.isTeamNotEmpty())
      for (StatName statName in PokemonStats.statNamesIterable()) {
        int sumStat = 0;
        for (PokemonInstance pokemon in team.teamMembers) {
          sumStat += pokemon.getStatFromNameStat(statName);
        }
        widgetsStats.add(Column(children: [
          Text(PokemonStats.statNameToString(statName),
              textAlign: TextAlign.left,
              style: PokeCustomTheme.getFieldStyle()),
          SizedBox(
            height: 8.0,
          ),
          SinglePokeStat(
            stat: (sumStat / team.teamMembers.length).truncate(),
            maxValue: 500,
          ),
          SizedBox(
            height: 20.0,
          )
        ]));
      }
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 20, 50, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: widgetsStats,
          ),
        ),
      ),
    );
  }
}
