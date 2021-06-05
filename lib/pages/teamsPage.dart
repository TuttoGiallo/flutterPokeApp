import 'package:flutter/material.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/services/loaderDB.dart';
import 'package:poke_team/widgets/deleteBackGround.dart';
import 'package:poke_team/widgets/teams-widget/addATeamDialog.dart';
import 'package:poke_team/widgets/teams-widget/teamTile.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key key}) : super(key: key);

  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  List<Team> teams;
  LoaderDB loaderDB;
  bool firstLoad = true; //TODO: capire perché nell'initState non posso accedere ai valori del ModalRoute...

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

  @override
  Widget build(BuildContext context) {
    if(firstLoad){
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
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AddATeamDialog(onAddedTeam: onAddedTeam));
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
                teams.removeAt(index); //TODO: cancellazione da DB
                loaderDB.deleteTeam(team);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${team.name} deleted')));
            },
            background: DeleteBackground(),
            child: TeamTile(
                team: team,
                onTeamTap: (Team t) async {
                  await Navigator.pushNamed(context, '/team',
                      arguments: {'team': team});
                  setState(() {                  });
                }),
          );
        },
      ),
    );
  }
}
