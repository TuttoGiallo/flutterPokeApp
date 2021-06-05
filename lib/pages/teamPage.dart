import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/services/loaderDB.dart';
import 'package:poke_team/services/loadingApi.dart';
import 'package:poke_team/widgets/deleteBackGround.dart';
import 'package:poke_team/widgets/team-widget/addAPokemonDialog.dart';
import 'package:poke_team/widgets/team-widget/pokemonListTile.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key key}) : super(key: key);

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Team team;

  LoaderDB loaderDB;
  bool firstLoad =
      true; //TODO: capire perché nell'initState non posso accedere ai valori del ModalRoute...

  @override
  void initState() {
    loaderDB = LoaderDB();
    super.initState();
  }

  onAddedPokemon(String pokemonNameOrId) async {
    dynamic mapAddedPokemon =
        await Navigator.pushNamed(context, '/loading', arguments: {
      'pokemonName': pokemonNameOrId,
      'team': team,
      'add': 'true',
    });
    if (mapAddedPokemon['ex_code'] == 1) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Pokemon non trovato'),
          content: const Text('Il nome o l\'ID inserito non è corretto.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (mapAddedPokemon['pokemon'] != null ? true : false) {
        setState(() {
          team.addPokemon(mapAddedPokemon['pokemon']);
          loaderDB.storePokemonInstanceInTeam(mapAddedPokemon['pokemon']);
        });
      }
    }
  }

  onDeletePokemonFromTeam(PokemonInstance pokemon){
    team.removePokemon(pokemon);
    loaderDB.deletePokemonInTeam(pokemon);
  }

  Future<void> onPokemonTapForInfo(PokemonInstance pokemon) async {
    await Navigator.pushNamed(context, '/loading',
        arguments: {'pokemonInstance': pokemon, 'add': 'false'}); //TODO quando sarà paremetrizzato non si potrà passare il nome ma si dovrà passare l'intero pokemon
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad) {
      firstLoad = false;
      Map argsTeam = ModalRoute.of(context).settings.arguments;
      this.team = argsTeam['team'];
    }

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text(team.name),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      floatingActionButton: Visibility(
        visible: team.isTeamNotFull(),
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AddAPokemonDialog(
                      allPokemonName: LoadingApi.getAllPokemonName(),
                      onAddedPokemon: onAddedPokemon,
                    ));
          },
          label: const Text('Add a Pokemon'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.amber,
        ),
      ),
      body: Container(
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
                  ],
                )),
            children: team.teamMembers
                .map((pokemon) => Dismissible(
                      key: UniqueKey(), //key dupplicata per spostamento e
                      onDismissed: (direction) {
                        setState(() {
                          onDeletePokemonFromTeam(pokemon);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${pokemon.name} delete')));
                      },
                      // Show a red background as the item is swiped away.
                      background: DeleteBackground(),
                      child: Container(
                        //TODO: spostare il widget "teamPoke"
                        key: ValueKey(pokemon),
                        child: PokemonListTile(pokemon: pokemon, onPokemonTapForInfo: onPokemonTapForInfo),
                      ),
                    ))
                .toList(),
            // The reorder function
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final poke = team.teamMembers.removeAt(oldIndex);
                team.teamMembers..insert(newIndex, poke);
              });
            }),
      ),
    );
  }
}
