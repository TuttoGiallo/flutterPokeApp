import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poke_team/model/ability.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonItem.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokeTypeContainer.dart';
import 'package:poke_team/widgets/pokemon-widget/pokeItemInfo.dart';

import '../alertDialogInputString.dart';
import 'pokeAbilityInfo.dart';

class PokeInfoCard extends StatefulWidget {
  const PokeInfoCard(
      {Key key,
      @required this.editing,
      @required this.pokemon,
      @required this.pokemonItemList,
      @required this.onAddButtonPressed,
      @required this.onUpdatePokemonValues})
      : super(key: key);
  final PokemonInstance pokemon;
  final bool editing;
  final Function(BuildContext context, PokemonInstance pokemon)
      onAddButtonPressed;
  final Function(PokemonInstance pokemonInstance) onUpdatePokemonValues;
  final List<PokemonItem> pokemonItemList;

  @override
  _PokeInfoCardState createState() => _PokeInfoCardState();
}

class _PokeInfoCardState extends State<PokeInfoCard> {
  PokemonInstance pokemonInstance;
  Ability selectedAbility;
  List<PokemonItem> pokemonItemListWithNullItem;
  PokemonItem selectedItem;
  PokemonItem itemNull;

  @override
  void initState() {
    pokemonInstance = widget.pokemon;
    selectedAbility = this.widget.pokemon.abilities.firstWhere(
        (ability) => pokemonInstance.abilitySelected.name == ability.name);
    pokemonItemListWithNullItem = [];
    pokemonItemListWithNullItem.addAll(widget.pokemonItemList);
    itemNull = PokemonItem('no item', '', ItemCategory.heldItems);
    pokemonItemListWithNullItem.add(itemNull);
    selectedItem = pokemonInstance.item != null
        ? pokemonItemListWithNullItem
            .firstWhere((item) => item.name == pokemonInstance.item.name)
        : itemNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: spostare in init?
    List<Widget> widgetsAbility = [];
    this.widget.pokemon.abilities.forEach((ability) {
      widgetsAbility.add(PokeAbilityInfo(ability: ability));
    });

    List<DropdownMenuItem<Ability>> dropDownAbility = [];
    this.widget.pokemon.abilities.forEach((ability) {
      dropDownAbility.add(DropdownMenuItem<Ability>(
          value: ability, child: PokeAbilityInfo(ability: ability)));
    });

    List<DropdownMenuItem<PokemonItem>> dropDownItem = [];
    this.pokemonItemListWithNullItem.forEach((item) {
      dropDownItem.add(DropdownMenuItem<PokemonItem>(
          value: item, child: PokeItemInfo(item: item)));
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
                  child: Text(
                    '${pokemonInstance.firstName}',
                    style: PokeCustomTheme.getValueStyle(),
                  ),
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
                                  helpText:
                                      'Enter the surname of your pokemon.',
                                ));
                        if (returnFromDialog['ok'] &&
                            returnFromDialog['inputText']
                                .toString()
                                .isNotEmpty) {
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
                )),
            Visibility(
              visible: !widget.editing,
              child: Column(
                children: widgetsAbility,
              ),
            ),
            Visibility(
              visible: widget.editing,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 34.0,
                  ),
                  Text('Item', style: PokeCustomTheme.getFieldStyle()),
                  SizedBox(
                    height: 8.0,
                  ),
                  DropdownButton<PokemonItem>(
                    iconSize: 40,
                    iconEnabledColor: Colors.grey[200],
                    value: selectedItem,
                    items: dropDownItem,
                    onChanged: (item) {
                      setState(() {
                        selectedItem = item;
                        pokemonInstance.item =
                            item != this.itemNull ? item : null;
                        widget.onUpdatePokemonValues(pokemonInstance);
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
