import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/services/loaderDB.dart';
import 'package:poke_team/widgets/alertDialogInputString.dart';
import 'package:poke_team/widgets/deleteBackGround.dart';
import 'package:poke_team/widgets/teams-widget/teamTile.dart';

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

  cancelDelete(Team team){
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

  @override
  Widget build(BuildContext context) {
    Duration durationSnackbar = Duration(milliseconds: 3000);

    if (firstLoad) {
      firstLoad = false;
      List<Team> argsTeams = ModalRoute.of(context).settings.arguments;
      teams = argsTeams ?? [];
    }

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('My Teams'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false, //disable back arrow
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      body: ListView.builder(
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
                        child: Text('Cancel', style: TextStyle(color: Colors.blueAccent),),
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
                      );
                    });
              },
            ),
          );
        },
      ),
    );
  }
}

class OnPressTeamMenu extends StatelessWidget {
  const OnPressTeamMenu(
      {Key key,
      @required this.team,
      @required this.onRenamedTeam,
      @required this.onCloneTeam})
      : super(key: key);
  final Team team;
  final Function(Team team, String name) onRenamedTeam;
  final Function(Team team) onCloneTeam;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Team Menu:'),
      children: [
        OnPressTeamMenuItem(
          icon: Icons.text_fields,
          color: Colors.grey,
          text: 'rename',
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RenameATeamDialog(
                      team: team, onRenamedTeam: onRenamedTeam);
                });
            Navigator.pop(context, 'rename');
          },
        ),
        OnPressTeamMenuItem(
          icon: Icons.copy,
          color: Colors.grey,
          text: 'clone',
          onPressed: () async {
            onCloneTeam(team);
            Navigator.pop(context, 'clone');
          },
        ),
      ],
    );
  }
}

class OnPressTeamMenuItem extends StatelessWidget {
  const OnPressTeamMenuItem(
      {Key key, this.icon, this.color, this.text, this.onPressed})
      : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed; //TODO capire cosa significa VoidCallback

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class RenameATeamDialog extends StatelessWidget {
  RenameATeamDialog(
      {Key key, @required this.onRenamedTeam, @required this.team})
      : super(key: key);

  final Function(Team team, String teamName) onRenamedTeam;
  final TextEditingController textController = new TextEditingController();
  final Team team;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename a Team:'),
      content: SizedBox(
        width: 250,
        child: TextField(
            controller: textController,
            key: key,
            decoration:
                const InputDecoration(helperText: "Enter the team's name"),
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.grey[800],
              fontStyle: FontStyle.italic,
            )),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onRenamedTeam(team, textController.text);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
