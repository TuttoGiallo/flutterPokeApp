import 'package:flutter/material.dart';
import 'package:poke_team/model/nature.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/widgets/pokemon-widget/natureCard.dart';

class PokeStatsCard extends StatefulWidget {
  const PokeStatsCard(
      {Key key, @required this.pokemon, @required this.onUpdatePokemonValues})
      : super(key: key);

  final PokemonInstance pokemon;
  final Function(PokemonInstance pokemonInstance) onUpdatePokemonValues;

  @override
  _PokeStatsCardState createState() => _PokeStatsCardState();
}

class _PokeStatsCardState extends State<PokeStatsCard> {
  PokemonInstance pokemonInstance;
  Nature selectedNature;
  List<DropdownMenuItem<Nature>> dropDownNature;

  @override
  void initState() {
    pokemonInstance = widget.pokemon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Nature> allNatures = Nature.getAllNatures();
    selectedNature = allNatures
        .firstWhere((nature) => pokemonInstance.nature.name == nature.name);

    dropDownNature = [];
    allNatures.forEach((nature) {
      dropDownNature.add(DropdownMenuItem<Nature>(
          value: nature, child: NatureCard(nature: nature)));
    });

    return Container(
      child: Column(
        children: [
          Center(child: Text('Pokemon Nature:')),
          DropdownButton<Nature>(
            iconSize: 40,
            iconEnabledColor: Colors.grey[200],
            value: selectedNature,
            items: dropDownNature,
            onChanged: (nature) {
              setState(() {
                selectedNature = nature;
                pokemonInstance.nature = nature;
                widget.onUpdatePokemonValues(pokemonInstance);
              });
            },
          )
        ],
      ),
    );
  }
}
