import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';

class AnimatedSwitchedPokemonDetails extends StatelessWidget {
  const AnimatedSwitchedPokemonDetails({
    Key key,
    @required this.open,
    @required this.team,
    @required this.statName,
    this.checkAbility = false,
    this.checkItem = false,
  }) : super(key: key);

  final bool open;
  final Team team;
  final StatName statName;
  final bool checkAbility;
  final bool checkItem;

  @override
  Widget build(BuildContext context) {
    List<Widget> pokemonStatDetails = [];

    team
        .getANewListOfMemeberSortedByStat(statName,
            abilityCheck: checkAbility, itemCheck: checkItem)
        .forEach((pokemon) {
      pokemonStatDetails.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pokemon.name,
                style: PokeCustomTheme.getValueStyle(fontSize: 22),
              ),
              Text(
                '${pokemon.getStatFromNameStat(statName, abilityCheck: checkAbility, itemCheck: checkItem)}',
                style: TextStyle(
                  fontSize: 22,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          Divider(
              color: Colors.amber,
          )
        ],
      ));
    });

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: Visibility(
        visible: open,
        key: ValueKey<String>('HP $open'),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Column(
            children: pokemonStatDetails,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}
