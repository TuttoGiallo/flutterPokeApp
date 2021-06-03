import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/teamV1.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:tuple/tuple.dart';

class TeamWidgetV1 extends StatefulWidget {
  const TeamWidgetV1(
      {Key key,
      @required this.team,
      @required this.allPokemonName,
      @required this.onAddPokemonInTeam,
      @required this.onPokemonTapForInfo,
      @required this.onDeletePokemonFromTeam})
      : super(key: key);

  final TeamV1 team;
  final List<String> allPokemonName;
  final Function(String pokemonNameId) onAddPokemonInTeam;
  final Function(Pokemon pokemon) onDeletePokemonFromTeam;
  final Function(Pokemon pokemon) onPokemonTapForInfo;

  @override
  _TeamWidgetV1State createState() => _TeamWidgetV1State();
}

class _TeamWidgetV1State extends State<TeamWidgetV1> {
  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      primary: Colors.cyan[600],
      onPrimary: Colors.grey[800],
      onSurface: Colors.grey,
      textStyle: const TextStyle(fontSize: 20));

  ElevatedButton addButton;

  Function() onPressDelete = () {};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: ReorderableListView(
          header: Container(
              padding: const EdgeInsets.all(25),
              color: Colors.amber[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pokemon:',
                    style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                  ),
                  Container(
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: widget.team.isTeamFull()
                              ? null
                              : () async {
                                  Tuple2<bool, String> resultAddDialog;
                                  resultAddDialog =
                                      await showDialog<Tuple2<bool, String>>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertPokemonAdd(
                                            allPokemonName:
                                                widget.allPokemonName),
                                  );
                                  if (resultAddDialog.item1) {
                                    widget.onAddPokemonInTeam(
                                        resultAddDialog.item2);
                                  }
                                },
                          child: Row(
                            children: [
                              const Text('Add'),
                              Icon(Icons.add),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed:
                              widget.team.isTeamEmpty() ? null : onPressDelete,
                          child: Row(
                            children: [
                              const Text('Delete'),
                              Icon(Icons.delete),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          children: widget.team.teamMembers
              .map((pokemon) => Dismissible(
                    key: UniqueKey(), //key dupplicata per spostamento e
                    // Provide a function that tells the app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        widget.onDeletePokemonFromTeam(pokemon);
                      });

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${pokemon.name} dismissed')));
                    },
                    // Show a red background as the item is swiped away.
                    background: Container(color: Colors.red),
                    child: Container(
                      //TODO: spostare il widget "teamPoke"
                      key: ValueKey(pokemon),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border:
                              Border.all(width: 1, color: Colors.grey[800])),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(4, 15, 20, 10),
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 30,
                          child: GestureDetector(
                            onTap: () async =>
                                await widget.onPokemonTapForInfo(pokemon),
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
                        trailing: Icon(Icons.drag_handle_outlined, size: 45),
                      ),
                    ),
                  ))
              .toList(),
          // The reorder function
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final poke = widget.team.teamMembers.removeAt(oldIndex);
              widget.team.teamMembers..insert(newIndex, poke);
            });
          }),
    );
  }
}

class AlertPokemonAdd extends StatelessWidget {
  const AlertPokemonAdd({Key key, @required this.allPokemonName})
      : super(key: key);
  final List<String> allPokemonName;

  @override
  Widget build(BuildContext context) {
    String pokemonName = '';
    return AlertDialog(
      title: const Text('Add Pokemon in Team:'),
      content: SizedBox(
        width: 250,
        //TODO: size fissa mi sembra una minchiata
        child:
            //definizione di un widget (del suo nome) nel momento stesso in cui vieni definito nel return.
            AutoCompleteTextField<String>(
                //TODO cambiare da string name a oggetto pair name/id
                clearOnSubmit: false,
                key: key,
                decoration: const InputDecoration(
                    helperText: "Enter Pokemon name or IDß"),
                suggestions: allPokemonName,
                itemBuilder: (context, pokemonName) {
                  return Container(
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        pokemonName,
                        style: TextStyle(fontSize: 20, color: Colors.grey[300]),
                      ),
                    ),
                  ); //TODO: presentare il nome e l'id nella ricerca
                },
                itemFilter: (pokemonName, inputText) {
                  //TODO: cambiare in coppia name,id. ricorda
                  return pokemonName.contains(inputText);
                },
                itemSorter: (pokemonName1, pokemonName2) {
                  return pokemonName1.compareTo(pokemonName2);
                },
                itemSubmitted: (pn) {
                  pokemonName = pn;
                },
                style: TextStyle(
                  fontSize: 28.0,
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                )),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () =>
              Navigator.pop(context, new Tuple2<bool, String>(false, '')),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
              context, new Tuple2<bool, String>(true, pokemonName)),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
