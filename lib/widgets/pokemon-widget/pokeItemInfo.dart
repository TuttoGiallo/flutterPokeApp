import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonItem.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';

class PokeItemInfo extends StatelessWidget {
  const PokeItemInfo({Key key, @required this.item}) : super(key: key);

  final PokemonItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 150,
            child: Text(
              item.name,
              style: PokeCustomTheme.getValueStyle(),
              overflow: TextOverflow.ellipsis,
            )),
        //    Visibility( //TODO: aggiugnere oggetti consumabili
        //        visible: item.consumabile,
        //        child: Text('(C)',
        //            style: TextStyle(fontSize: 18, color: Colors.grey[300]))),
        IconButton(
          color: Colors.grey[300],
          icon: Icon(
            Icons.info_outlined,
            size: 30,
          ),
          onPressed: () => showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(item.name),
              content: Text(item.description),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('OK'),
                ),
                //TODO: "view more" espande la alert box, la rende scroll e mostra il contenuto della descrizione dell'intero effetto
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
