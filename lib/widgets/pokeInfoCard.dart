import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_team/model/ability.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokeTypeContainer.dart';

class PokeInfoCard extends StatelessWidget {
  const PokeInfoCard(
      {Key key,
      @required this.addButtonVisibility,
      @required this.poke,
      @required this.onAddButtonPressed})
      : super(key: key);
  final Pokemon poke;
  final bool addButtonVisibility;
  final Function(BuildContext context, Pokemon pokemon) onAddButtonPressed;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetsAbility = [];
    this.poke.abilities.forEach((ability) {
      widgetsAbility.add(PokeAbilityInfo(ability: ability));
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 105,
              child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[400],
                  backgroundImage: NetworkImage(
                    poke.urlSprite,
                  )),
            ),
            SizedBox(
              height: 38.0,
            ),
            Text('Name', style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            Text('${poke.name}', style: PokeCustomTheme.getValueStyle()),
            SizedBox(
              height: 34.0,
            ),
            Text('ID #', style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            Text('${poke.id}', style: PokeCustomTheme.getValueStyle()),
            SizedBox(
              height: 34.0,
            ),
            Text(poke.type2 == null ? 'Type' : 'Types',
                style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PokeTypeContainer(poke.type1),
                SizedBox(height: 5.0),
                Visibility(
                  visible: poke.type2 == null ? false : true,
                  child: PokeTypeContainer(poke.type2),
                ),
              ],
            ),
            SizedBox(
              height: 34.0,
            ),
            Text('Abilities', style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            Column(
              children: widgetsAbility,
            ),
            SizedBox(
              height: 34.0,
            ),
            Visibility(
              visible: addButtonVisibility,
              child: Container(
                margin: EdgeInsets.all(10),
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () => onAddButtonPressed(context, this.poke),
                  //TODO: test
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                  ),
                  child: Text("Aggiungi",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PokeAbilityInfo extends StatelessWidget {
  const PokeAbilityInfo({Key key, @required this.ability}) : super(key: key);

  final Ability ability;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(ability.name, style: PokeCustomTheme.getValueStyle()),
        Visibility(
            visible: ability.hidden,
            child: Text('(hidden)',
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
