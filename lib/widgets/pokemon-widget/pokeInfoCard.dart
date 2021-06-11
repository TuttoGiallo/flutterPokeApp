import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_team/model/ability.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokeTypeContainer.dart';

import '../alertDialogInputString.dart';

class PokeInfoCard extends StatefulWidget {
  const PokeInfoCard(
      {Key key,
      @required this.editing,
      @required this.pokemon,
      @required this.onAddButtonPressed,
      @required this.onUpdatePokemonValues})
      : super(key: key);
  final PokemonInstance pokemon;
  final bool editing;
  final Function(BuildContext context, PokemonInstance pokemon)
      onAddButtonPressed;
  final Function(PokemonInstance pokemonInstance) onUpdatePokemonValues;

  @override
  _PokeInfoCardState createState() => _PokeInfoCardState();
}

class _PokeInfoCardState extends State<PokeInfoCard> {
  PokemonInstance pokemonInstance;
  Ability selectedAbility;

  @override
  void initState() {
    pokemonInstance = widget.pokemon;
    selectedAbility = this.widget.pokemon.abilities.firstWhere((ability) => pokemonInstance.abilitySelected.name == ability.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetsAbility = [];
    this.widget.pokemon.abilities.forEach((ability) {
      widgetsAbility.add(PokeAbilityInfo(ability: ability));
    });

    List<DropdownMenuItem<Ability>> dropDownAbility = [];
    this.widget.pokemon.abilities.forEach((ability) {
      dropDownAbility.add(DropdownMenuItem<Ability>(value: ability, child: PokeAbilityInfo(ability: ability)));
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
                  child: CachedNetworkImage(
                    imageUrl: widget.pokemon.urlSprite,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
            ),
            SizedBox(
              height: 38.0,
            ),
            Text('Name', style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  child: Text('${pokemonInstance.firstName}',
                      style: PokeCustomTheme.getValueStyle(),),
                ),
                Visibility(
                  visible: widget.editing,
                  child: IconButton(
                      onPressed: () async {
                        Map returnFromDialog = await showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialogInputString(
                                  title: 'Pokemon Name:',
                                  helpText: 'Enter the surname of your pokemon.',
                                ));
                        if (returnFromDialog['ok'] &&
                            returnFromDialog['inputText'].toString().isNotEmpty) {
                          setState(() => pokemonInstance.firstName =
                              returnFromDialog['inputText']);
                          widget.onUpdatePokemonValues(pokemonInstance);
                        }
                      },
                      icon: Icon(Icons.drive_file_rename_outline)),
                )
              ],
            ),
            SizedBox(
              height: 34.0,
            ),
            Text('ID #', style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            Text('${widget.pokemon.id}',
                style: PokeCustomTheme.getValueStyle()),
            SizedBox(
              height: 34.0,
            ),
            Text(widget.pokemon.type2 == null ? 'Type' : 'Types',
                style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PokeTypeContainer(widget.pokemon.type1),
                SizedBox(height: 5.0),
                Visibility(
                  visible: widget.pokemon.type2 == null ? false : true,
                  child: PokeTypeContainer(widget.pokemon.type2),
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
            Visibility(
              visible: widget.editing,
              child: DropdownButton<Ability>(
                iconSize: 40,
                iconEnabledColor: Colors.grey[200],
                value: selectedAbility,
                items: dropDownAbility,
                onChanged: (ability) {
                  setState(() {
                    selectedAbility = ability;
                    pokemonInstance.abilitySelected = ability;
                    widget.onUpdatePokemonValues(pokemonInstance);
                  });
                },
              )
            ),
            Visibility(
              visible: !widget.editing,
              child: Column(
                children: widgetsAbility,
              ),
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}

//TODO spostare in file a parte
class PokeAbilityInfo extends StatelessWidget {
  const PokeAbilityInfo({Key key, @required this.ability}) : super(key: key);

  final Ability ability;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width: 150, child: Text(ability.name, style: PokeCustomTheme.getValueStyle(), overflow: TextOverflow.ellipsis,)),
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
