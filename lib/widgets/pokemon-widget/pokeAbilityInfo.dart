import 'package:flutter/material.dart';
import 'package:poke_team/model/ability.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';

class PokeAbilityInfo extends StatelessWidget {
  const PokeAbilityInfo({Key key, @required this.ability}) : super(key: key);

  final Ability ability;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 150,
            child: Text(
              ability.name,
              style: PokeCustomTheme.getValueStyle(),
              overflow: TextOverflow.ellipsis,
            )),
        Visibility(
            visible: ability.hidden,
            child: Text('(H)',
                style: TextStyle(fontSize: 18, color: Colors.grey[300]))),
        IconButton(
          color: Colors.grey[300],
          icon: Icon(
            Icons.info_outlined,
            size: 30,
          ),
          onPressed: () => showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(ability.name),
              content: Text(ability.shortEffect),
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
