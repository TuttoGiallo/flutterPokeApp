import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';

class PokemonListTile extends StatelessWidget {
  const PokemonListTile(
      {Key key, @required this.pokemon, @required this.onPokemonTapForInfo})
      : super(key: key);
  final PokemonInstance pokemon;
  final Future<void> Function(PokemonInstance pokemon) onPokemonTapForInfo;

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.elliptical(20, 40),
                topRight: Radius.elliptical(100, 40)),
          ),
          tileColor: Colors.grey[300],
          contentPadding: EdgeInsets.fromLTRB(4, 15, 20, 10),
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 30,
            child: GestureDetector(
              onTap: () async => await onPokemonTapForInfo(pokemon),
              child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[400],
                  backgroundImage: NetworkImage(
                    pokemon.urlSprite,
                  )),
            ),
          ),
          title: Text(
            pokemon.name,
            style: TextStyle(fontSize: 24),
          ),
          trailing: Icon(
            Icons.drag_handle_outlined,
            size: 45,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
