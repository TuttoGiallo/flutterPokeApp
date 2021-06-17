import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/services/loaderDB.dart';
import 'package:poke_team/widgets/alertDialogInputString.dart';
import 'package:poke_team/widgets/alertDialogText.dart';
import 'package:poke_team/widgets/deleteBackGround.dart';
import 'package:poke_team/widgets/teams-widget/importTeam.dart';
import 'package:poke_team/widgets/teams-widget/onPressTeamMenu.dart';
import 'package:poke_team/widgets/teams-widget/teamTile.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key key}) : super(key: key);

  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  List<Team> teams;
  LoaderDB loaderDB;
  bool firstLoad =
      true; //TODO: capire perché nell'initState non posso accedere ai valori del ModalRoute...
  bool deleting = true;

  @override
  void initState() {
    loaderDB = LoaderDB();
    super.initState();
  }

  onAddedTeam(String teamName) {
    Team team = new Team(teamName);
    setState(() {
      teams.add(team);
    });
    loaderDB.storeNewTeam(team);
  }

  onRenamedTeam(Team team, String teamNewName) {
    setState(() {
      team.name = teamNewName;
    });
    loaderDB.renameTeam(team);
  }

  onShareTextTeam(Team team) {
    String encodedTeam = jsonEncode(team.toJson());
    Share.share(encodedTeam);
  }

  //TODO verificare suo funzionamento
  String getPrettyJSONString(jsonObject) {
    var encoder = new JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }

  //TODO ccontrolli sul team: ad esempio se sto inserendo 7 pokemon, se metto nomi che non esistono di oggetti...
  //altro modo, ma più stupido, è quello di provare a criptare e poi decriptare la stringa, così che non sia modificabile da fuori.
  onImportTeam(String jsonTeam) {
    if (jsonTeam.isEmpty) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialogText(
                textTitle: 'Import Team:',
                textContent: 'Text area empty',
              ));
      return;
    }
    try {
      Map decodedTeam = jsonDecode(jsonTeam);
      print(decodedTeam['team']['name']);
      Team newTeam = Team(decodedTeam['team']['name']);
      LoaderDB().storeNewTeam(newTeam).then((dbKeyTeam) {
        print(decodedTeam['members']);
        for (dynamic pokemonMap in decodedTeam['members']) {
          print(pokemonMap['name']);
          PokemonInstance newAddedPokemon =
              PokemonInstance.fromMap(-1, pokemonMap, newTeam);
          loaderDB
              .storePokemonInstanceInTeam(newAddedPokemon)
              .then((newDbKey) => newAddedPokemon.dbKey = newDbKey);
          newTeam.addPokemon(newAddedPokemon);
        }
        setState(() {
          teams.add(newTeam);
          _selectedItem = 'Teams';
        });
      });
    } on FormatException catch (ex) {
      print('error formta in input');
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialogText(
                textTitle: 'Import Team:',
                textContent: 'Format of team unexpected',
              ));
      return;
    }
  }

  onCloneTeam(Team team) async {
    //TODO await this, altrimenti rischio di non avere la chiave DB corretta, spinner sul dialog?!
    Team newTeam = new Team.fromMap(-1, team.map);
    await loaderDB.storeNewTeam(
        newTeam); //TODO comportamento differente store team e pokemon
    for (PokemonInstance pokemon in team.teamMembers) {
      PokemonInstance newPokemon =
          new PokemonInstance.fromMap(newTeam.dbKey, pokemon.map, newTeam);
      int pokeDbKey = await loaderDB.storePokemonInstanceInTeam(newPokemon);
      newPokemon.dbKey = pokeDbKey;
      newTeam.addPokemon(newPokemon);
    }
    setState(() {
      teams.add(newTeam);
    });
  }

  cancelDelete(Team team) {
    setState(() => teams.add(team));
    deleting = false;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  tryToDeleteTeam(Team team) {
    if (deleting) {
      loaderDB.deleteTeam(team);
    } else {
      setState(() {
        deleting = true;
      });
    }
  }

  String _selectedItem = 'Teams';
  final Map<String, int> _menuStringIndex = {
    'Teams': 0,
    'Import Team': 1,
    'Settings': 2,
    //'Editing': 3,
  };

  @override
  Widget build(BuildContext context) {
    Duration durationSnackbar = Duration(milliseconds: 3000);

    if (firstLoad) {
      firstLoad = false;
      teams = loaderDB.getAllTeamsFromLastDBLoad() ?? [];
    }

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('My Teams'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            iconSize: 35,
            color: Colors.grey[800],
            itemBuilder: (BuildContext bc) {
              return _menuStringIndex.keys
                  .map((teamOption) => PopupMenuItem(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20),
                        child: Text(teamOption),
                        value: teamOption,
                        textStyle: TextStyle(
                          color: teamOption != _selectedItem
                              ? Colors.grey[300]
                              : Colors.amber,
                          fontSize: 20,
                        ),
                      ))
                  .toList();
            },
            onSelected: (value) {
              setState(() {
                _selectedItem = value;
              });
            },
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _selectedItem == 'Teams',
        child: FloatingActionButton.extended(
          onPressed: () async {
            Map returnFromDialog = await showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialogInputString(
                      title: 'Add a Team:',
                      helpText: 'Enter the name of the new team',
                    ));
            if (returnFromDialog != null && returnFromDialog['ok']) {
              onAddedTeam(returnFromDialog['inputText']);
            }
          },
          label: const Text('Add a new Team!'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.amber,
        ),
      ),
      body: IndexedStack(
        index: _menuStringIndex[_selectedItem],
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/pika.png"),
                fit: BoxFit.scaleDown,
              ),
            ),
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      teams.removeAt(index);
                    });
                    Future.delayed(durationSnackbar)
                        .then((value) => tryToDeleteTeam(team));

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: durationSnackbar,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${team.name} deleted'),
                            TextButton(
                              onPressed: () => cancelDelete(team),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            )
                          ],
                        )));
                  },
                  //TODO se cancello un pokemon, poi il team, e poi annullo la cancellazione del pokemon?
                  background: DeleteBackground(),
                  child: TeamTile(
                    team: team,
                    onTeamTap: (Team t) async {
                      await Navigator.pushNamed(context, '/team',
                          arguments: {'team': team});
                      setState(() {});
                    },
                    onTeamLongPress: (Team team) async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return OnPressTeamMenu(
                              team: team,
                              onRenamedTeam: onRenamedTeam,
                              onCloneTeam: onCloneTeam,
                              onShareTextTeam: onShareTextTeam,
                            );
                          });
                    },
                  ),
                );
              },
            ),
          ),
          ImportTeam(
            onImportTeam: onImportTeam,
          ),
          Text('Settings'),
        ],
      ),
    );
  }
}
