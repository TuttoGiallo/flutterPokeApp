import 'package:flutter/material.dart';
import 'package:poke_team/model/nature.dart';
import 'package:poke_team/model/pokemonStats.dart';

import '../borderText.dart';

class NatureCard extends StatelessWidget {
  const NatureCard({Key key, @required this.nature}) : super(key: key);
  final Nature nature;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BorderText(
          text: nature.getNatureNameToString(),
          fontSize: 24,
        ),
        SizedBox(width: 16,),
        Row(
          children: [
            BorderText(
              text: '+${PokemonStats.statNameToAbbreviation(nature.up)}',
              fontSize: 20,
            ),
            SizedBox(
              width: 8,
            ),
            BorderText(
              text: '-${PokemonStats.statNameToAbbreviation(nature.down)}',
              fontSize: 20,
            ),
          ],
        ),
      ],
    );
  }
}
