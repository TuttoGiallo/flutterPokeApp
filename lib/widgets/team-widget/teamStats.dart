import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokemon-widget/singlePokeStat.dart';

import 'animatedSwitcherPokemonDetails.dart';

class TeamStats extends StatefulWidget {
  const TeamStats({Key key, @required this.team}) : super(key: key);
  final Team team;

  @override
  _TeamStatsState createState() => _TeamStatsState();
}

class _TeamStatsState extends State<TeamStats> {
  bool checkAbility = false;
  bool checkItem = false;

  bool openHP = false;
  Map<StatName, bool> openPokemonDetails = {};

  @override
  void initState() {
    PokemonStats.statNamesIterable()
        .forEach((stat) => openPokemonDetails[stat] = false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetsStats = [];
    if (widget.team.isTeamNotEmpty())
      for (StatName statName in PokemonStats.statNamesIterable()) {
        int sumStat = 0;
        for (PokemonInstance pokemon in widget.team.teamMembers) {
          sumStat += pokemon.getStatFromNameStat(statName,
              abilityCheck: checkAbility, itemCheck: checkItem);
        }
        widgetsStats.add(
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(PokemonStats.statNameToString(statName),
                  textAlign: TextAlign.left,
                  style: PokeCustomTheme.getFieldStyle()),
              IconButton(
                icon: Icon(
                  Icons.expand,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => openPokemonDetails[statName] =
                    !openPokemonDetails[statName]),
              ),
            ],
          ),
          AnimatedSwitchedPokemonDetails(
            open: openPokemonDetails[statName],
            pokemonList: widget.team.teamMembers,
            statName: statName,
            checkAbility: checkAbility,
            checkItem: checkItem,
          ),
          SizedBox(
            height: 8.0,
          ),
          SinglePokeStat(
            stat: (sumStat / widget.team.teamMembers.length).truncate(),
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
          padding: const EdgeInsets.fromLTRB(40.0, 20, 40, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    //alignment: Alignment.topRight,
                    child: Text(
                      'Check Ability:',
                      style: PokeCustomTheme.getValueStyle(),
                    ),
                  ),
                  Switch(
                    value: checkAbility,
                    onChanged: (value) {
                      setState(() {
                        checkAbility = value;
                      });
                    },
                    activeTrackColor: Colors.blueAccent,
                    activeColor: Colors.blueAccent,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    //alignment: Alignment.topRight,
                    child: Text(
                      'Check Item:',
                      style: PokeCustomTheme.getValueStyle(),
                    ),
                  ),
                  Switch(
                    value: checkItem,
                    onChanged: (value) {
                      setState(() {
                        checkItem = value;
                      });
                    },
                    activeTrackColor: Colors.blueAccent,
                    activeColor: Colors.blueAccent,
                  ),
                ],
              ),
              SizedBox(
                height: 35,
              ),
            ]..addAll(widgetsStats),
          ),
        ),
      ),
    );
  }
}
