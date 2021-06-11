import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';

import '../pokeTypeContainer.dart';
class PokeHiddenPowerCard extends StatelessWidget {
  const PokeHiddenPowerCard({Key key, @required this.pokemonInstance}) : super(key: key);
  final PokemonInstance pokemonInstance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(38),
      child: Column(
        children: [
          Text('Hidden Power: ', style: PokeCustomTheme.getFieldStyle()),
          Container(margin: EdgeInsets.symmetric(vertical: 10),child: PokeTypeContainer(pokemonInstance.hiddenPowerType)),
          Text('Damage: ${pokemonInstance.hiddenPowerDamage}', style: PokeCustomTheme.getValueStyle()),
        ],
      ),

    );
  }
}
