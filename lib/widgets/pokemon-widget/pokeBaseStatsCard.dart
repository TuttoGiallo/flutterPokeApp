import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokemon-widget/singlePokeStat.dart';

class PokeBaseStatsCard extends StatelessWidget {
  const PokeBaseStatsCard({Key key, @required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetsStats = [];//TODO controllare se si può spostare nell'init!
    for(StatName bsName in pokemon.baseStats.keys){
      widgetsStats.add(
        Column(
        children:[ Text(PokemonStats.statNameToString(bsName),
            textAlign: TextAlign.left,
            style: PokeCustomTheme.getFieldStyle()),
        SizedBox(
          height: 8.0,
        ),
        SinglePokeStat(stat: pokemon.baseStats[bsName], maxValue: 200),
        SizedBox(
          height: 20.0,
        )]
        )
      );
    }
    
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0,20,50,0),
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


