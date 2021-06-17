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
    @required this.pokemonList,
    @required this.statName,
    this.checkAbility = false,
    this.checkItem = false,
    this.statsToPrint,
  }) : super(key: key);

  final bool open;
  final List<PokemonInstance> pokemonList;
  final StatName statName;
  final bool checkAbility;
  final bool checkItem;
  final List<StatName> statsToPrint;

  @override
  Widget build(BuildContext context) {
    List<StatName> allStatToPrint = [];
    allStatToPrint.add(statName);
    if (statsToPrint != null) allStatToPrint.addAll(statsToPrint);

    List<Widget> detailsStatsPokemonPreviewsNames = [];
    allStatToPrint
        .forEach((stat) => detailsStatsPokemonPreviewsNames.add(Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                PokemonStats.statNameToAbbreviation(stat),
                style: PokeCustomTheme.getFieldStyle(fontSize: 18),
              ),
            )));

    List<Widget> pokemonStatDetails = [];
    for (PokemonInstance pokemon in Team.getANewListOfMemberSortedByStat(
        pokemonList, statName,
        abilityCheck: checkAbility, itemCheck: checkItem)) {
      List<Widget> detailsStatsPokemonPreviews = [];
      allStatToPrint.forEach((stat) {
        detailsStatsPokemonPreviews.add(Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: DetailsStatsPokemonPreview(
            pokemon: pokemon,
            statName: stat,
            checkItem: checkItem,
            checkAbility: checkAbility,
          ),
        ));
      });

      pokemonStatDetails.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                child: Text(
                  pokemon.name,
                  overflow: TextOverflow.ellipsis,
                  style: PokeCustomTheme.getValueStyle(fontSize: 22),
                ),
              ),
              Row(
                children: detailsStatsPokemonPreviews,
              )
            ],
          ),
          Divider(
            color: Colors.amber,
          )
        ],
      ));
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: Visibility(
        visible: open,
        key: ValueKey<String>('$open'),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pokemon:',
                    style: PokeCustomTheme.getValueStyle(fontSize: 18),
                  ),
                  Row(
                    children: detailsStatsPokemonPreviewsNames,
                  ),
                ],
              ),
              SizedBox(height: 10,),
            ]..addAll(pokemonStatDetails),
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

class DetailsStatsPokemonPreview extends StatelessWidget {
  const DetailsStatsPokemonPreview(
      {Key key,
      @required this.pokemon,
      @required this.statName,
      @required this.checkAbility,
      @required this.checkItem})
      : super(key: key);

  final PokemonInstance pokemon;
  final StatName statName;
  final bool checkAbility;
  final bool checkItem;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${pokemon.getStatFromNameStat(statName, abilityCheck: checkAbility, itemCheck: checkItem)}',
      style: TextStyle(
        fontSize: 22,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}
